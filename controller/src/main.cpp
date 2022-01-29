#include <Arduino.h>

#include "common/DataUtils.hpp"
#include "common/Time.hpp"
#include "communication/Json.hpp"
#include "communication/MQTT.hpp"
#include "communication/WiFi/Wifi.hpp"
#include "sensor/SensorsManager.hpp"

void setup() {
  Logger::setup();
  SensorsManager::setup();
  Wifi::setup();
  Time::sync();
  MQTT::setup();
  MQTT::connect();
}

void loop() {
  if (!Wifi ::isConnected()) {
    try {
      Wifi::setup();
    } catch (const Exception& e) {
      return delay(1000);
    }
  }

  auto data = SensorsManager::poll();
  DataUtils::print(data);

  data.time = time(nullptr);

  auto serialized = Json::serialize(data);
  Logger::debugln(serialized);

  MQTT::send(serialized);

  delay(10000);
}
