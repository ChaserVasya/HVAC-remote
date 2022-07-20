#include <Arduino.h>

#include "common/DataUtils.hpp"
#include "common/Led.hpp"
#include "common/Sleep.hpp"
#include "common/Time.hpp"
#include "communication/Json.hpp"
#include "communication/WiFi/Wifi.hpp"
#include "injection.hpp"
#include "sensor/SensorsManager.hpp"
#include "soc/rtc_cntl_reg.h"

/// HELPERS

DataDTO pollData() {
  SensorsManager::setup();
  return SensorsManager::poll();
}

void send(DataDTO data) {
  data.time = Time::time();

  Logger::debugln(F("MQTT: Sending: start "));

  auto serialized = Json::serialize(data);

  Logger::debugln(String("MQTT: Sending: Json: ") + serialized);

  mqtt->send(serialized);

  Logger::debugln(F("MQTT: Sending: sended "));
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
  Wifi::setup();
  Time::sync();
  mqtt->setup();
  mqtt->connect();
}

void logResetReasonIfUnexpected() {
  auto reason = esp_reset_reason();

  if (reason == ESP_RST_DEEPSLEEP || reason == ESP_RST_POWERON) return;

  auto exc = ResetException(reason);
  auto serialized = Json::serialize(exc);
  Logger::debugln(serialized);
}

void disableBrownoutDetector() { WRITE_PERI_REG(RTC_CNTL_BROWN_OUT_REG, 0); }

/// MAIN FUNCTIONS

void setup() {
  disableBrownoutDetector();

  Led::powerOn();
  Logger::setup();

  logResetReasonIfUnexpected();

  // TODO Wifi somehow affects on polling. Check how
  auto data = pollData();

  try {
    tryConnectWithWorld();
    // sendResetReasonIfUnexpected();
    send(data);
  } catch (...) {
    Logger::debugln("Uncaught exceptin");
  }

  Led::powerOff();
  Sleep::sleep();
}

void loop() {}
