#pragma once

#include <WString.h>

typedef uint32_t ID;

struct MessageHeader {
  ID id;
};

template <typename DTO>
struct Request {
  MessageHeader header;
  DTO body;

  Request(DTO body = DTO(), MessageHeader header = MessageHeader()) : header(header), body(body);
};
