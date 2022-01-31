#pragma once

#include "Exception.hpp"
#include "common/Logger.hpp"

// In next versions will send exceptions to the server
class ExceptionHandler {
 public:
  static void handle(const Exception &exc) { Logger::println(exc.toString()); }
};