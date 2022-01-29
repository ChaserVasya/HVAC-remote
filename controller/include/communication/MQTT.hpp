#pragma once

#include <Arduino.h>
#include <MQTTClient.h>
#include <WiFiClientSecure.h>

#include "CloudIoTCore.h"
#include "CloudIoTCoreDevice.h"
#include "CloudIoTCoreMqtt.h"
#include "Wifi.h"

class MQTT {
  static CloudIoTCoreMqtt *mqtt;
  static WiFiClientSecure *netClient;
  static MQTTClient *mqttClient;

  static void setupSecurity();

 public:
  static CloudIoTCoreDevice *device;

  static void setup();

  static void connect();
  static void loop();
  static void send(String serialized);
};

const int jwt_exp_secs = 3600 * 20;
