#pragma once

#include <Arduino.h>

#define D "Debug: "
#define L "Logger: "

class Logger {
 public:
  static bool verbose;
  static bool printDebug;

  static void setup() {
    Serial.begin(9600);
    Serial.println();
    debugln(F(D L "Inited"));
  }

  template <typename T>
  static void println(const T& msg) {
    if (verbose) Serial.println(msg);
  }

  template <typename T>
  static void print(const T& msg) {
    if (verbose) Serial.print(msg);
  }

  template <typename T>
  static void debug(const T& msg) {
    if (verbose && printDebug) Serial.print(msg);
  }

  template <typename T>
  static void debugln(const T& msg) {
    if (verbose && printDebug) Serial.println(msg);
  }

  static void debugln() {
    if (verbose && printDebug) Serial.println();
  }
};
