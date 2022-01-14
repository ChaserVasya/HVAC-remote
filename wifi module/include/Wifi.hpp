#pragma once

#include <Arduino.h>

#include "ESP8266WiFi.h"
#include "Logger.hpp"
#include "Wifi.hpp"

class Wifi {
 public:
  static void setup() {
    // const String ssid = "TP-Link_2102";
    // const String password = "58098257";

    const String ssid = "mamaaa, just killed a maaan";
    const String password = "hehehehe";

    WiFi.mode(WIFI_STA);
    WiFi.begin(ssid, password);

    Serial.print("Connecting to WiFi");

    while (WiFi.status() != WL_CONNECTED) {
      delay(1000);
      Serial.print('.');
    }
    Serial.println();
  }
};
