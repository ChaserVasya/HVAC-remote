#pragma once

#include <time.h>

#include "common/Logger.hpp"

class Time {
 public:
  static void sync() {
    Logger::debugln(F("Time: synchronization"));

    const char *ntp_server1 = "time.google.com";
    const char *ntp_server2 = "pool.ntp.org";
    const char *ntp_server3 = "ntp3.stratum2.ru";
    const long programUploadTime = 1636975648;

    configTzTime("<+10>-10", ntp_server1, ntp_server2, ntp_server3);

    while (time(nullptr) < programUploadTime) delay(500);
  }
};