#include "Json.hpp"

template <typename DTO>
JsonDoc Json::createDoc(const Request<DTO>& request) {
  JsonDoc doc;

  doc[F("header")][F("id")] = request.header.id;
  doc[F("body")] = serialize(request.body);

  return doc;
};

// template <>
// Request<DataDTO> Json::createStruct<Request<DataDTO>>(const JsonDoc& doc) {
//   Request<DataDTO> request;

//   request.body = deserialize<DataDTO>(doc[F("body")].as<String>());
//   request.header.id = doc[F("header")][F("id")];

//   return request;
// };


JsonDoc Json::createDoc(const DataDTO& str) {
  JsonDoc doc;

  doc[F("temperature")] = str.temperature;
  doc[F("illuminance")] = str.illuminance;
  doc[F("UNOBatteryVoltage")] = str.UNOBatteryVoltage;
  doc[F("ESPBatteryVoltage")] = str.ESPBatteryVoltage;

  return doc;
}

template <>
DataDTO Json::createStruct<DataDTO>(const JsonDoc& doc) {
  DataDTO dto;

  dto.illuminance = doc[F("illuminance")];
  dto.temperature = doc[F("temperature")];
  dto.UNOBatteryVoltage = doc[F("UNOBatteryVoltage")];
  dto.ESPBatteryVoltage = doc[F("ESPBatteryVoltage")];

  return dto;
};
