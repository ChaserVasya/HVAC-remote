#pragma once

#include <Arduino.h>

#define Db "Debug: "
#define L "Logger: "

class Logger {
 public:
  static bool verbose;
  static bool printDebug;

  // Must call this in setup start before other classes usage
  // because they can call Logger methods
  static void setup() {
    Serial.begin(9600);
    Serial.println();
    debugln(F(Db L "Inited"));
  }

  template <typename T>
  static void println(const T& msg) {
    if (verbose) Serial.println(msg);
  }

  static void println() {
    if (verbose) Serial.println();
  }

  template <typename T>
  static void print(const T& msg) {
    if (verbose) Serial.print(msg);
  }

  template <typename T>
  static void debug(const T& msg) {
    if (verbose && printDebug) Serial.print(msg);
  }

  static void debug(const double num, const uint8_t precision) {
    if (verbose && printDebug) Serial.print(num, precision);
  }

  template <typename T>
  static void debugln(const T& msg) {
    if (verbose && printDebug) Serial.println(msg);
  }

  static void print(const double num, const uint8_t precision) {
    if (verbose) Serial.print(num, precision);
  }

  static void println(const double num, const uint8_t precision) {
    if (verbose) Serial.println(num, precision);
  }

  static void debugln() {
    if (verbose && printDebug) Serial.println();
  }
};
