#include "communication/Json.hpp"

typedef StaticJsonDocument<128> JsonDoc;

template <class Struct>
static Struct createStruct(const JsonDoc& doc);

template <class Struct>
static JsonDoc createDoc(const Struct& str);

template <>
JsonDoc createDoc(const DataDTO& str) {
  JsonDoc doc;

  doc[F("temperature")] = str.temperature;
  doc[F("illuminance")] = str.illuminance;
  doc[F("batteryVoltage")] = str.batteryVoltage;

  return doc;
}

template <>
DataDTO createStruct<DataDTO>(const JsonDoc& doc) {
  DataDTO dto;

  dto.illuminance = doc[F("illuminance")];
  dto.temperature = doc[F("temperature")];
  dto.batteryVoltage = doc[F("batteryVoltage")];

  return dto;
};

namespace Json {
template <class Struct>
String serialize(const Struct& str) {
  return createDoc(str).template as<String>();
};

template <class Struct>
Struct deserialize(const String& string) {
  JsonDoc doc;
  auto err = deserializeJson(doc, string);
  if (err) throw JsonException(err.code(), err.c_str());

  Struct str = createStruct<Struct>(doc);

  return str;
};
}  // namespace Json
