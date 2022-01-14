#pragma once

#include <Arduino.h>
#include <MQTTClient.h>

#include "CloudIoTCore.h"
#include "CloudIoTCoreDevice.h"
#include "CloudIoTCoreMqtt.h"
#include "ESP8266WiFi.h"
#include "WiFiClientSecureBearSSL.h"

class MQTT {
  static CloudIoTCoreMqtt *mqtt;
  static WiFiClientSecure *netClient;
  static MQTTClient *mqttClient;

 public:
  static CloudIoTCoreDevice *device;

  static void setupSecurity();
  static void setup();

  static void connect();
  static void loop();
};

const int jwt_exp_secs = 3600 * 20;
