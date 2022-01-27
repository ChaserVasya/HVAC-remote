#pragma once

#include <WString.h>

class StringUtils {
 public:
  static String addQuotas(String str) {
    static const String quota = "\"";
    return quota + str + quota;
  }
};