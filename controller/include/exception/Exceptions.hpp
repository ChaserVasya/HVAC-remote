#pragma once

#include <ArduinoJson.h>

#include "exception/Exception.hpp"

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

class WiFiException : public Exception {
 public:
  WiFiException(int code = 0, String description = "") : Exception(code, description) {}

 protected:
  String obj() const override { return "Json"; }

  String code2String(int code) const override {
    switch (code) {
      case 0:
        return "Ok";
      case 1:
        return "Not connected";
    }
    return "Unknown";
  }
};