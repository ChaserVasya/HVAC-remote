#pragma once

#include "ESP8266WiFi.h"
#include "TZ.h"

class Time {
 public:
  static void syncTime() {
    const char *ntp_server1 = "time.google.com";
    const char *ntp_server2 = "pool.ntp.org";
    const char *ntp_server3 = "ntp3.stratum2.ru";
    const long programUploadTime = 1636975648;

    configTime(TZ_Asia_Vladivostok, ntp_server1, ntp_server2, ntp_server3);

    Serial.println("time syncing");
    while (time(nullptr) < programUploadTime) {
      delay(500);
    }
    Serial.println("synced");
  }
};