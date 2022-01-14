#include "Bridge.hpp"

#include "Logger.hpp"
#include "StringUtils.hpp"

#define D "Debug: "
#define B "Bridge: "
#define Sp "Setup: "
#define H "Handshake: "
#define S "Sending: "
#define R "Read: "
#define RW "Responce waiting: "
#define C "Common: "
#define KC "Keyword check: "

BridgeException Bridge::timedReadString(String& buf) {
  auto start = millis();
  while (serial.available()) {
    buf += (char)serial.read();
    if (!serial.available()) delay(pauseTimeout);
    if (millis() - start > safeTimeout)
      return BridgeException(BridgeException::TimeoutIsOver,
                             String("Infinity input. Current read: ") + '\"' + buf + '\"');
  }
  return BridgeException();
}

void Bridge::waitInputEnd() {
  uint16_t newDatumNumber = serial.available();
  uint16_t lastDatumNumber;

  do {
    lastDatumNumber = newDatumNumber;
    delay(pauseTimeout);
    newDatumNumber = serial.available();
  } while (newDatumNumber != lastDatumNumber);
}

void Bridge::flushBuffers() {
  Logger::debugln(F(D B C "Flushing buffers"));
  serial.flush();
  while (serial.read() > 0)
    ;
}

BridgeException Bridge::waitForResponce(int timeout) {
  Logger::debugln(F(D B RW "Start"));
  while (timeout-- > 0) {
    delay(10);
    if (serial.available()) {
      waitInputEnd();
      Logger::debugln(F(D B RW "Received"));
      return BridgeException();
    }
  }
  Logger::debugln(F(D B RW "Timeout is over"));
  return BridgeException(BridgeException::TimeoutIsOver);
}

BridgeException Bridge::handshake() {
  Logger::debugln(F(D B H "Start"));

  BridgeException exc;

  flushBuffers();
  Logger::debugln(F(D B H "Keyword sending"));
  serial.print(handshakeWord);
  Logger::debugln(String(D B H "Keyword ") + StringUtils::addQuotas(handshakeWord) + " is sended");
  Logger::debugln(String(D B H "Waiting for ") + StringUtils::addQuotas(handshakeWord) + " keyword");
  exc = waitForResponce();
  if (exc) {
    Logger::debugln(F(D B H "Fail"));
    return exc;
  }
  Logger::debugln(F(D B H "Responce is received"));
  exc = checkResponceKeyword(handshakeWord);
  if (exc) {
    Logger::debugln(F(D B H "Fail"));
    return exc;
  }
  Logger::debugln(F(D B H "Responce keyword is right"));
  return exc;
}

BridgeException Bridge::checkResponceKeyword(const String& rightKeyword) {
  Logger::debugln(F(D B KC "Reading from serial"));
  // auto responceKeyword = serial.readString();
  String responceKeyword;
  auto exc = timedReadString(responceKeyword);
  Logger::debugln(String(D B KC "Input: ") + StringUtils::addQuotas(responceKeyword));
  if (exc) {
    Logger::debugln(F(D B KC "Infinity read"));
    return exc;
  }
  if (responceKeyword == rightKeyword) {
    Logger::debugln(F(D B KC "Keyword is right"));
    return BridgeException();
  } else {
    const auto errorDescription = String("Wrong keyword: ") + StringUtils::addQuotas(responceKeyword);
    Logger::debugln(D B KC + errorDescription);
    return BridgeException(BridgeException::WrongResponceWord, errorDescription);
  }
}

bool Bridge::isSetuped() { return _isSetuped; };

BridgeException Bridge::setup() {
  Logger::debugln(F(D B Sp "Start"));

  serial.begin(maxControllerBaudRate);
  serial.setTimeout(pauseTimeout);
  const auto exc = handshake();
  _isSetuped = exc ? false : true;

  if (_isSetuped)
    Logger::debugln(F(D B Sp "Success"));
  else
    Logger::debugln(F(D B Sp "Fail"));

  return exc;
}

BridgeException Bridge::send(const String& str) {
  BridgeException exc;
  Logger::debugln(F(D B S "Start"));
  flushBuffers();
  serial.print(str);
  exc = waitForResponce();
  if (exc) {
    Logger::debugln(F(D B S "Fail"));
    return exc;
  }
  exc = checkResponceKeyword(receivedWorld);
  if (exc) {
    Logger::debugln(F(D B S "Fail"));
    return exc;
  }
  Logger::debugln(F(D B S "Success"));
  return exc;
}

String Bridge::read() {
  Logger::debugln(F(D B R "Start"));
  waitInputEnd();
  const auto str = serial.readString();
  if (str.length() != 0) {
    Logger::debugln(String(D B R "Input: ") + StringUtils::addQuotas(str));
    serial.print(receivedWorld);
    Logger::debugln(String(D B R "Sending ") + StringUtils::addQuotas(receivedWorld) + " keyword");
  } else {
    Logger::debugln(F(D B R "Empty input"));
  }
  return str;
}

const unsigned long Bridge::maxControllerBaudRate = 38400;

const unsigned long Bridge::safeTimeout = 2000;
const unsigned long Bridge::responceTimeout = 1000;
const unsigned long Bridge::pauseTimeout = 10;

const String Bridge::handshakeWord = "Hello";
const String Bridge::receivedWorld = "Received";

bool Bridge::_isSetuped = false;

SoftwareSerial Bridge::serial = SoftwareSerial(2, 3);
