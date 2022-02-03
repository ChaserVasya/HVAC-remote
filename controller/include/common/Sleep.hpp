#pragma once

#include <Arduino.h>
#include <esp_bt.h>
#include <esp_bt_main.h>
#include <esp_sleep.h>
#include <esp_wifi.h>

#include "Logger.hpp"

class Sleep {
  static constexpr uint16_t sleepSec = 5 * 60;

  static void prepareForSleep() {
    esp_bluedroid_disable();
    esp_bluedroid_deinit();
    esp_bt_controller_disable();
    esp_bt_controller_deinit();
    esp_wifi_stop();
    esp_wifi_deinit();
    Serial.flush();
    Serial.end();
  }

 public:
  static void sleep() {
    constexpr uint32_t sec2usFactor = 1000000;

    Logger::debugln(F("Sleep: sleep"));

    prepareForSleep();

    esp_deep_sleep(sleepSec * sec2usFactor);
  }
};