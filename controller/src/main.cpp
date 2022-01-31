#include <Arduino.h>

#include "common/Sleep.hpp"
#include "common/Time.hpp"
#include "communication/Json.hpp"
#include "communication/MQTT.hpp"
#include "communication/WiFi/Wifi.hpp"
#include "sensor/SensorsManager.hpp"

void pollDataAndSend() {
  SensorsManager::setup();

  auto data = SensorsManager::poll();
  data.time = Time::time();

  auto serialized = Json::serialize(data);
  MQTT::send(serialized);

  Logger::debugln(String("Sended data: ") + serialized);
}

void sendResetReasonIfUnexpected() {
  auto reason = esp_reset_reason();

  if (reason == ESP_RST_DEEPSLEEP || reason == ESP_RST_POWERON) return;

  auto exc = ResetException(reason);
  auto serialized = Json::serialize(exc);
  MQTT::send("/exceptions", serialized);

  Logger::debugln(serialized);
}

void tryConnectWithWorld() {
  try {
    Wifi::setup();
    Time::sync();
    MQTT::setup();
    MQTT::connect();
  } catch (...) {
    Sleep::sleep();
  }
}

void setup() {
  Logger::setup();

  tryConnectWithWorld();
  sendResetReasonIfUnexpected();
  pollDataAndSend();

  Sleep::sleep();
}

void loop() {}
