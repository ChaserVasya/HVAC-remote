#include "communication/Json.hpp"

template <>
JsonDoc Json::createDoc(const DataDTO& str) {
  JsonDoc doc;

  doc[F("temperature")] = str.temperature;
  doc[F("illuminance")] = str.illuminance;
  doc[F("batteryVoltage")] = str.batteryVoltage;
  doc[F("time")] = str.time;

  return doc;
}

template <>
DataDTO Json::createStruct<DataDTO>(const JsonDoc& doc) {
  DataDTO dto;

  dto.illuminance = doc[F("illuminance")];
  dto.temperature = doc[F("temperature")];
  dto.batteryVoltage = doc[F("batteryVoltage")];
  dto.time = doc[F("time")];

  return dto;
};
