#pragma once

#include <Arduino.h>
#include <MQTTClient.h>
#include <WiFiClientSecure.h>

#include "CloudIoTCore.h"
#include "CloudIoTCoreDevice.h"
#include "CloudIoTCoreMqtt.h"
#include "Wifi.h"

// uses google iot example like google iot specific mqtt settings.
// the foofle example is a fast prototype not for usage.
// so there are many ugly solutions like var definition by users,
// Serial prints inside inaccessive methods,
// bad logic splitting
// many side effect and others.
// So, this class tries to hide this.
//
// In next versions I will rewrite all this class and googles class.
class MQTT {
  static CloudIoTCoreMqtt *mqtt;
  static WiFiClientSecure *netClient;
  static MQTTClient *mqttClient;

  // Sets certs and keys
  static void setupSecurity();

 public:
  static CloudIoTCoreDevice *device;

  // init clients
  static void setup();

  // set connection to server.
  static void connect();

  // receives input
  static void loop();

  static void send(String serialized);
  static void send(String subtopic, String serialized);
};

const int jwt_exp_secs = 3600 * 20;
