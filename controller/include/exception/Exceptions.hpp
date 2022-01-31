#pragma once

#include <ArduinoJson.h>

#include "exception/Exception.hpp"

class JsonException : public Exception {
 public:
  JsonException(DeserializationError::Code code = DeserializationError::Ok, String description = "")
      : Exception(code, description) {}

  String object() const override { return "Json"; }

 protected:
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

  String object() const override { return "WiFi"; }

 protected:
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

class ResetException : public Exception {
 public:
  ResetException(int code = 0) : Exception(code, "") {}

  String object() const override { return "Reset"; }

 protected:
  String code2String(int code) const override {
    switch (code) {
      case ESP_RST_UNKNOWN:
        return "ESP_RST_UNKNOWN";
      case ESP_RST_POWERON:
        return "ESP_RST_POWERON";
      case ESP_RST_EXT:
        return "ESP_RST_EXT";
      case ESP_RST_SW:
        return "ESP_RST_SW";
      case ESP_RST_PANIC:
        return "ESP_RST_PANIC";
      case ESP_RST_INT_WDT:
        return "ESP_RST_INT_WDT";
      case ESP_RST_TASK_WDT:
        return "ESP_RST_TASK_WDT";
      case ESP_RST_WDT:
        return "ESP_RST_WDT";
      case ESP_RST_DEEPSLEEP:
        return "ESP_RST_DEEPSLEEP";
      case ESP_RST_BROWNOUT:
        return "ESP_RST_BROWNOUT";
      case ESP_RST_SDIO:
        return "ESP_RST_SDIO";
      default:
        return "unknown";
    }
  }
};