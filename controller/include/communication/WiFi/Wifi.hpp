#pragma once

#include <Arduino.h>
#include <WiFi.h>

#include "WiFiConfig.hpp"
#include "common/Logger.hpp"
#include "common/StringUtils.hpp"
#include "exception/Exceptions.hpp"

class Wifi {
  constexpr static unsigned long connectionTimeout = 5000;

 public:
  static bool isConnected() { return WiFi.isConnected(); }

  static void setup() {
    WiFi.mode(WIFI_STA);

    for (const auto conf : wifiConfigs) {
      Logger::debugln(String("WiFi: Connecting to ") + StringUtils::addQuotas(conf.ssid));
      const auto start = millis();
      WiFi.begin(conf.ssid, conf.password);
      while (millis() - start < connectionTimeout) {
        if (WiFi.isConnected()) return;
        delay(1);
      }
      WiFi.disconnect();
    }

    throw WiFiException(1);
  }
};
