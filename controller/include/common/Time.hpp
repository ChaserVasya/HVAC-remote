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
    constexpr long programUploadTime = 1636975648;
    const char *tz = "<+10>-10";

    configTzTime(tz, ntp_server1, ntp_server2, ntp_server3);

    while (::time(nullptr) < programUploadTime) delay(500);
  };

  static time_t time() { return ::time(nullptr); }
};