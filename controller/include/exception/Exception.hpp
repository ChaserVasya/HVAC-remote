#pragma once

#include "Arduino.h"
#include "common/Logger.hpp"

class Exception {
 public:
  int code;
  String description;
  virtual String object() const = 0;

  Exception(int code, String description) : code(code), description(description) {}

  // For exception check like "if (exc){...}"
  explicit operator bool() const { return code; }

  String toString() const {
    String buf;
    buf += "Exception: ";
    buf += object() + ": ";
    buf += "Error code: " + code2String(code) + "; ";
    if (description.isEmpty()) buf += "Description: " + description;

    return buf;
  }

 protected:
  virtual String code2String(int code) const = 0;
};
