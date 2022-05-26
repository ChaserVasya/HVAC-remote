#pragma once

#include <Arduino.h>
#include <MQTTClient.h>
#include <WiFiClientSecure.h>

#include "CloudIoTCoreDevice.h"
#include "Interface.hpp"
#include "Wifi.h"

class YandexMQTT : public MQTT {
  static constexpr uint8_t maxAttempts = 5;
  static constexpr const char *topic = "events";
  static constexpr const char *cliendID = "controller";
  static constexpr const char *password = nullptr;
  static constexpr const char *username = nullptr;

  WiFiClientSecure *netClient = new WiFiClientSecure;
  MQTTClient *mqttClient = new MQTTClient(1000);

  // Sets certs and keys
  void setupSecurity();

  void logReturnCode();
  void logError();

 public:
  // init clients
  void setup();

  // set connection to server.
  void connect();

  // receives input
  void loop();

  void send(String serialized);
  void send(String subtopic, String serialized);
};
