#pragma once

#include <SoftwareSerial.h>

#include "Exceptions.hpp"

class Bridge {
 private:
  static SoftwareSerial serial;

  static const unsigned long maxControllerBaudRate;

  static const unsigned long responceTimeout;
  static const unsigned long pauseTimeout;
  static const unsigned long safeTimeout;

  static const String handshakeWord;
  static const String receivedWorld;

  static bool _isSetuped;

  static BridgeException timedReadString(String& buf);

  static void waitInputEnd();
  static void flushBuffers();
  static BridgeException waitForResponce(int timeout = responceTimeout);
  static BridgeException handshake();
  static BridgeException checkResponceKeyword(const String& rightKeyword);

 public:
  static bool isSetuped();
  static BridgeException setup();
  static BridgeException send(const String& str);
  static String read();
};
