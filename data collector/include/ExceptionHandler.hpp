#pragma once

#include <ArduinoJson.h>

#include "Bridge.hpp"
#include "Exception.hpp"
#include "Logger.hpp"

class ExceptionHandler {
 public:
  static void handle(const Exception &exc) { Logger::println(exc.toString()); }
};