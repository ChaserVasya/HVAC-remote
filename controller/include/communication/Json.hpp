#pragma once

#include <ArduinoJson.h>

#include "domain/DataDTO.hpp"
#include "exception/Exceptions.hpp"

namespace Json {
template <class Struct>
String serialize(const Struct& str);

template <class Struct>
Struct deserialize(const String& string);
};  // namespace Json
