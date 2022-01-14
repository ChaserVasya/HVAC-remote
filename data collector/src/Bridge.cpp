#include "Bridge.hpp"

#include <ArduinoJson.h>

#include "Exceptions.hpp"
#include "Json.hpp"
#include "Logger.hpp"
#include "Request.hpp"
#include "StringUtils.hpp"

#define D "Debug: "
#define Br "Bridge: "
#define Sp "Setup: "
#define H "Handshake: "
#define Sn "Sending: "
#define R "Read: "
#define RW "Responce waiting: "
#define Cm "Common: "
#define KC "Keyword check: "

void Bridge::timedReadString(String& buf) {
  auto start = millis();
  while (serial.available()) {
    buf += (char)serial.read();
    if (!serial.available()) delay(pauseTimeout);
    if (millis() - start > safeTimeout)
      throw BridgeException(BridgeException::TimeoutIsOver,
                            String("Infinity input. Current read: ") + StringUtils::addQuotas(buf));
  }
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
  Logger::debugln(F(D Br Cm "Flushing buffers"));
  serial.flush();
  while (serial.read() > 0)
    ;
}

void Bridge::waitForResponce(int timeout) {
  Logger::debugln(F(D Br RW "Start"));
  while (timeout-- > 0) {
    delay(10);
    if (serial.available()) {
      waitInputEnd();
      Logger::debugln(F(D Br RW "Received"));
      return;
    }
  }
  throw BridgeException(BridgeException::TimeoutIsOver);
}

void Bridge::handshake() {
  Logger::debugln(F(D Br H "Start"));
  flushBuffers();
  Logger::debugln(F(D Br H "Keyword sending"));
  serial.print(handshakeWord);
  Logger::debugln(String(D Br H "Keyword ") + StringUtils::addQuotas(handshakeWord) + " is sended");
  Logger::debugln(String(D Br H "Waiting for ") + StringUtils::addQuotas(handshakeWord) + " keyword");
  waitForResponce();
  Logger::debugln(F(D Br H "Responce is received"));
  checkResponceKeyword(handshakeWord);
  Logger::debugln(F(D Br H "Responce keyword is right"));
}

void Bridge::checkResponceKeyword(const String& rightKeyword) {
  Logger::debugln(F(D Br KC "Reading from serial"));
  String responceKeyword;
  timedReadString(responceKeyword);
  Logger::debugln(String(D Br KC "Input: ") + StringUtils::addQuotas(responceKeyword));
  if (responceKeyword == rightKeyword) {
    Logger::debugln(F(D Br KC "Keyword is right"));
  } else {
    const auto errorDescription = String("Wrong keyword: ") + StringUtils::addQuotas(responceKeyword);
    Logger::debugln(D Br KC + errorDescription);
    throw BridgeException(BridgeException::WrongResponceWord, errorDescription);
  }
}

void Bridge::setup() {
  serial.begin(maxControllerBaudRate);
  serial.setTimeout(pauseTimeout);
}

String Bridge::read() {
  Logger::debugln(F(D Br R "Start"));
  waitInputEnd();
  const auto str = serial.readString();
  if (str.length() != 0) {
    Logger::debugln(String(D Br R "Input: ") + StringUtils::addQuotas(str));
    serial.print(receivedWorld);
    Logger::debugln(String(D Br R "Sending ") + StringUtils::addQuotas(receivedWorld) + " keyword");
  } else {
    Logger::debugln(F(D Br R "Empty input"));
  }
  return str;
}

template <typename DTO>
void Bridge::send(const DTO& dto) {
  Logger::debugln(F(D Br Sn "Start"));

  auto request = Request(dto);
  auto serializedRequest =

      flushBuffers();
  serial.print(serializedRequest);
  waitForResponce();
  checkResponceKeyword(receivedWorld);

  Logger::debugln(F(D Br Sn "Success"));
}

const unsigned long Bridge::maxControllerBaudRate = 38400;

const unsigned long Bridge::safeTimeout = 2000;
const unsigned long Bridge::responceTimeout = 1000;
const unsigned long Bridge::pauseTimeout = 10;

const String Bridge::handshakeWord = "Hello";
const String Bridge::receivedWorld = "Received";

const ID IDManager::startID = 1;
ID IDManager::id = startID;

SoftwareSerial Bridge::serial = SoftwareSerial(2, 3);
