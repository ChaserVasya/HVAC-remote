#pragma once

#include <Arduino.h>

#include "DataDto.hpp"
#include "Logger.hpp"

class DataUtils {
 public:
  static void print(const DataDto& data) {
    Logger::println(F("=========="));

    Logger::print(F("Temp: "));
    Logger::print(data.temperature);
    Logger::println(F(" C"));

    Logger::print(F("Illuminance: "));
    Logger::print(data.illuminance);
    Logger::println(F(" Lux"));

    Logger::print(F("UNO battery voltage: "));
    Logger::print(data.UNOBatteryVoltage);
    Logger::println(F(" V"));

    Logger::print(F("ESP battery voltage: "));
    Logger::print(data.ESPBatteryVoltage);
    Logger::println(F(" V"));

    Logger::println(F("=========="));
  }
};