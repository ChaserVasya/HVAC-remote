#pragma once

#include <ArduinoJson.h>

#include "exception/Exception.hpp"

class BridgeException : public Exception {
 public:
  enum Code {
    NoException,
    WrongResponceWord,
    TimeoutIsOver,
  };

  BridgeException(Code code = NoException, String description = "") : Exception(code, description) {}

 protected:
  String obj() const override { return "Bridge"; }

  String code2String(int code) const override {
    switch (code) {
      case NoException:
        return "NoException";
      case WrongResponceWord:
        return "WrongResponceWord";
      case TimeoutIsOver:
        return "TimeoutIsOver";
    }
    return "Unknown";
  }
};

class JsonException : public Exception {
 public:
  JsonException(DeserializationError::Code code = DeserializationError::Ok, String description = "")
      : Exception(code, description) {}

 protected:
  String obj() const override { return "Json"; }

  String code2String(int code) const override {
    switch (code) {
      case DeserializationError::Ok:
        return "Ok";
      case DeserializationError::EmptyInput:
        return "EmptyInput";
      case DeserializationError::IncompleteInput:
        return "IncompleteInput";
      case DeserializationError::InvalidInput:
        return "InvalidInput";
      case DeserializationError::NoMemory:
        return "NoMemory";
      case DeserializationError::TooDeep:
        return "TooDeep";
    }
    return "Unknown";
  }
};
