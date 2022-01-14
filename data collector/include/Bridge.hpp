#pragma once

#include <SoftwareSerial.h>

class IDManager {
  static const ID startID;  // 0 is reserved
  static ID id;

  static void checkForOverflowing() {
    if (id < startID) id = startID;
  }

 public:
  static ID generate() {
    checkForOverflowing();
    return id++;
  }
};

class Bridge {
 private:
  static SoftwareSerial serial;

  static const unsigned long maxControllerBaudRate;

  static const unsigned long responceTimeout;
  static const unsigned long pauseTimeout;
  static const unsigned long safeTimeout;

  static const String handshakeWord;
  static const String receivedWorld;

  static void timedReadString(String& buf);

  static void waitInputEnd();
  static void flushBuffers();
  static void waitForResponce(int timeout = responceTimeout);
  static void handshake();
  static void checkResponceKeyword(const String& rightKeyword);

 public:
  static void setup();

  template <typename DTO>
  static void send(const DTO& dto);

  static String read();

  static void loop();
};
