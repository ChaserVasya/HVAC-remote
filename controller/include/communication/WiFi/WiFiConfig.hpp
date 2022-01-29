#pragma once

#include <vector>

struct WiFiConfig {
  const char* ssid;
  const char* password;

  WiFiConfig(const char* ssid, const char* password) : ssid(ssid), password(password) {}
};

const std::vector<WiFiConfig> wifiConfigs = {
    WiFiConfig({
        "mamaaa, just killed a maaan",
        "hehehehe",
    }),
    WiFiConfig({
        "TP-Link_2102",
        "58098257",
    }),
};