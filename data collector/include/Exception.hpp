#pragma once

#include "Arduino.h"
#include "Logger.hpp"

class Exception {
 public:
  int errorCode;
  String description;

  Exception(int errorCode, String description) : errorCode(errorCode), description(description) {}

  explicit operator bool() const { return errorCode; }

  String toString() const {
    String buf;
    buf += "Exception: ";
    buf += obj() + ": ";
    buf += "Error code: " + code2String(errorCode) + "; ";
    if (description.length()) buf += "Description: " + description;

    return buf;
  }

 protected:
  virtual String code2String(int code) const = 0;
  virtual String obj() const = 0;
};
