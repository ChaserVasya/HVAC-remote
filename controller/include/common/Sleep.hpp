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

    esp_sleep_pd_config(ESP_PD_DOMAIN_RTC_PERIPH, ESP_PD_OPTION_OFF);
    esp_sleep_pd_config(ESP_PD_DOMAIN_MAX, ESP_PD_OPTION_OFF);
    esp_sleep_pd_config(ESP_PD_DOMAIN_RTC_FAST_MEM, ESP_PD_OPTION_OFF);
    esp_sleep_pd_config(ESP_PD_DOMAIN_RTC_SLOW_MEM, ESP_PD_OPTION_OFF);
    esp_sleep_pd_config(ESP_PD_DOMAIN_XTAL, ESP_PD_OPTION_OFF);
    esp_deep_sleep(sleepSec * sec2usFactor);
  }
};