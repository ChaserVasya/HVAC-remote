#include <Arduino.h>

#include "common/DataUtils.hpp"
#include "common/Led.hpp"
#include "common/Sleep.hpp"
#include "common/Time.hpp"
#include "communication/Json.hpp"
#include "communication/WiFi/Wifi.hpp"
#include "injection.hpp"
#include "sensor/SensorsManager.hpp"

/// HELPERS

DataDTO pollData() {
  SensorsManager::setup();
  return SensorsManager::poll();
}

void send(DataDTO data) {
  data.time = Time::time();

  auto serialized = Json::serialize(data);
  mqtt->send(serialized);

  Logger::debugln(String("Sended data: ") + serialized);
}

void sendResetReasonIfUnexpected() {
  auto reason = esp_reset_reason();

  if (reason == ESP_RST_DEEPSLEEP || reason == ESP_RST_POWERON) return;

  auto exc = ResetException(reason);
  auto serialized = Json::serialize(exc);
  mqtt->send("/exceptions", serialized);

  Logger::debugln(serialized);
}

void tryConnectWithWorld() {
  try {
    Wifi::setup();
    Time::sync();
    mqtt->setup();
    mqtt->connect();
  } catch (...) {
    Sleep::sleep();
  }
}

/// MAIN FUNCTIONS

void setup() {
  Led::powerOn();
  Logger::setup();

  // TODO Wifi somehow affects on polling. Check how
  auto data = pollData();

  tryConnectWithWorld();
  sendResetReasonIfUnexpected();
  send(data);

  Led::powerOff();
  Sleep::sleep();
}

void loop() {}
