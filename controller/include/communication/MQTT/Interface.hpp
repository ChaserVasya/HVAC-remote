#pragma once

#include <Arduino.h>

class MQTT {
  // Sets certs and keys
  virtual void setupSecurity() = 0;

 public:
  // init clients
  virtual void setup() = 0;

  // set connection to server.
  virtual void connect() = 0;

  // receives input
  virtual void loop() = 0;

  virtual void send(String serialized) = 0;
  virtual void send(String subtopic, String serialized) = 0;
};
