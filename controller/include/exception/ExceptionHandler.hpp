#pragma once

#include "Exception.hpp"
#include "common/Logger.hpp"

class ExceptionHandler {
 public:
  static void handle(const Exception &exc) { Logger::println(exc.toString()); }
};