#pragma once

#include <vector>

struct WiFiConfig {
  const char* ssid;
  const char* password;

  WiFiConfig(const char* ssid, const char* password) : ssid(ssid), password(password) {}
};

const std::vector<WiFiConfig> wifiConfigs = {
    WiFiConfig({
        "RT-WiFi_5FE0",
        "Z2uQ6HHC",
    }),
    WiFiConfig({
        "TP-Link_2102",
        "58098257",
    }),
    WiFiConfig({
        "mamaaa, just killed a maaan",
        "hehehehe",
    }),

};