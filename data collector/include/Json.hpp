#pragma once

#include <ArduinoJson.h>

#include "DataDTO.hpp"
#include "Exceptions.hpp"
#include "Request.hpp"

typedef StaticJsonDocument<128> JsonDoc;

template <template <class> class Outer, class DTO>
class Json {
  template <typename Struct>
  static Struct createStruct(const JsonDoc& doc);

  static JsonDoc createDoc(const DataDTO& str);

  template <typename DTO>
  static JsonDoc createDoc(const Request<DTO>& str);

 public:
  template <typename Struct>
  static String serialize(const Struct& str) {
    return createDoc(str).template as<String>();
  }

  template <typename Struct>
  static Struct deserialize(const String& string) {
    JsonDoc doc;
    auto err = deserializeJson(doc, string);
    if (err) throw JsonException(err.code(), err.c_str());

    Struct str = createStruct<Struct>(doc);

    return str;
  }

  static Outer<DTO> createStruct(const JsonDoc& doc);
};

template <class DTO>
class Json<Request, DTO> {
  static Request<DTO> createStruct(const JsonDoc& doc) {
    Request<DTO> request;

    request.body = deserialize<DTO>(doc[F("body")].as<String>());
    request.header.id = doc[F("header")][F("id")];

    return request;
  };
};

template <>
Request<DataDTO> Json<Request, DataDTO>::createStruct(const JsonDoc& doc) {
  Request<DataDTO> request;

  request.body = deserialize<DataDTO>(doc[F("body")].as<String>());
  request.header.id = doc[F("header")][F("id")];

  return request;
};

// template <class SomeType, template <class> class OtherType>
// class NestedTemplateClass {
//   OtherType<SomeType> f;
// }

template <int a, int b, int c>
struct foo {
  void bar() {}
};
template <int a>
struct foo<a, 0, 0> {
  void bar() {}
};
