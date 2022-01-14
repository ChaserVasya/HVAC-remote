#pragma once

#include <ArduinoJson.h>

#include "DataDto.hpp"
#include "Exceptions.hpp"

class DataJson {
 public:
  static String serialize(const DataDto& data) {
    StaticJsonDocument<32> doc;

    doc[F("temperature")] = data.temperature;
    doc[F("illuminance")] = data.illuminance;
    doc[F("UNOBatteryVoltage")] = data.UNOBatteryVoltage;
    doc[F("ESPBatteryVoltage")] = data.ESPBatteryVoltage;

    String str;
    serializeJson(doc, str);

    return str;
  }

  static JsonException deserialize(const String& str, DataDto& data) {
    StaticJsonDocument<128> doc;

    auto err = deserializeJson(doc, str);

    if (err) return JsonException(err.code(), err.c_str());

    data.illuminance = doc[F("illuminance")];
    data.temperature = doc[F("temperature")];
    data.UNOBatteryVoltage = doc[F("UNOBatteryVoltage")];
    data.ESPBatteryVoltage = doc[F("ESPBatteryVoltage")];

    return JsonException();
  }
};