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
JsonDoc Json::createDoc(const ResetException& exc) {
  JsonDoc doc;

  doc[F("code")] = exc.code;
  doc[F("object")] = exc.object();

  return doc;
}