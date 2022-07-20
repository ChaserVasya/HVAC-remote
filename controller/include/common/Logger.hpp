#pragma once

#include <Arduino.h>

#include "FS.h"
#include "SPIFFS.h"

#define Db "Debug: "
#define L "Logger: "

// Unfinished class. In next versions there will be saving logs to EEPROM
// and sending warns and errors to the server.
//
// print methods should only print to serial
// debug methods are like print + saving to EEPROM (in next versions)
class Logger {
 public:
  static bool verbose;
  static bool printDebug;
  static bool shouldLog;

  // Must call this in setup start before other classes usage
  // because they can call Logger methods
  static void setup() {
    Serial.begin(9600);
    Serial.println();

    debugln(F(Db L "Inited"));
  }

  static void removeLog() {
    SPIFFS.begin(true);
    File file = SPIFFS.open("/spiffs/log.txt", FILE_WRITE);
    file.write('\0');
    file.close();
  }

  static void printLog() {
    SPIFFS.begin(true);
    File file = SPIFFS.open("/spiffs/log.txt");
    if (!file) {
      Serial.println("There was an error opening the file for writing");
      return;
    }
    Serial.println(F(Db L "========== OLD LOGS =========="));
    while (file.available()) {
      Serial.write(file.read());
    }
    Serial.println(F(Db L "========== OLD LOGS =========="));
    file.close();
  }

  template <typename T>
  static void log(const T& msg) {
    if (!shouldLog) return;

    SPIFFS.begin(true);
    File file = SPIFFS.open("/spiffs/log.txt", FILE_APPEND);
    if (!file) {
      Serial.println("There was an error opening the file for writing");
      return;
    }
    if (!file.println(msg)) {
      Serial.println("Can't write file");
      return;
    }
    file.close();
  }

  static void print(const double num, const uint8_t precision) {
    if (verbose) Serial.print(num, precision);
  }

  template <typename T>
  static void print(const T& msg) {
    log(msg);
    if (verbose) Serial.print(msg);
  }

  static void println() {
    if (verbose) Serial.println();
  }

  template <typename T>
  static void println(const T& msg) {
    log(msg);
    if (verbose) Serial.println(msg);
  }

  static void println(const double num, const uint8_t precision) {
    if (verbose) Serial.println(num, precision);
  }

  template <typename T>
  static void debug(const T& msg) {
    log(msg);
    if (verbose && printDebug) Serial.print(msg);
  }

  static void debug(const double num, const uint8_t precision) {
    if (verbose && printDebug) Serial.print(num, precision);
  }

  static void debugln() {
    if (verbose && printDebug) Serial.println();
  }

  template <typename T>
  static void debugln(const T& msg) {
    log(msg);
    if (verbose && printDebug) Serial.println(msg);
  }
};
