#pragma once

#include <ArduinoJson.h>

#include "domain/DataDTO.hpp"
#include "exception/Exceptions.hpp"

typedef StaticJsonDocument<128> JsonDoc;

class Json {
  template <class Struct>
  static Struct createStruct(const JsonDoc& doc);

  template <class Struct>
  static JsonDoc createDoc(const Struct& str);

 public:
  template <class Struct>
  static String serialize(const Struct& str) {
    return createDoc(str).template as<String>();
  };

  template <class Struct>
  static Struct deserialize(const String& string) {
    JsonDoc doc;

    auto err = deserializeJson(doc, string);
    if (err) throw JsonException(err.code(), err.c_str());

    Struct str = createStruct<Struct>(doc);

    return str;
  };
};
