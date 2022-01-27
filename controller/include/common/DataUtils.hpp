#pragma once

#include <Arduino.h>

#include "Logger.hpp"
#include "domain/DataDTO.hpp"

class DataUtils {
 public:
  static void print(const DataDTO& data) {
    Logger::println(F("=========="));

    Logger::print(F("Temp: "));
    Logger::print(data.temperature, 3);
    Logger::println(F(" C"));

    Logger::print(F("Illuminance: "));
    Logger::print(data.illuminance, 3);
    Logger::println(F(" Lux"));

    Logger::print(F("battery voltage: "));
    Logger::print(data.batteryVoltage, 3);
    Logger::println(F(" V"));

    Logger::println(F("=========="));
  }
};