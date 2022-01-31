#pragma once

#include <Arduino.h>
#include <esp_sleep.h>
#include <esp_wifi.h>

#include "Logger.hpp"

class Sleep {
  static constexpr uint16_t sleepSec = 15 * 60;

 public:
  static void sleep() {
    constexpr uint32_t sec2usFactor = 1000000;

    Logger::debugln(F("Sleep: Preparing"));

    esp_wifi_stop();
    esp_wifi_deinit();
    Serial.flush();

    Logger::debugln(F("Sleep: sleep"));

    esp_deep_sleep(sleepSec * sec2usFactor);
  }
};