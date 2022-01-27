#include <Arduino.h>
#include <driver/adc.h>
#include <esp_adc_cal.h>

#include "common/DataUtils.hpp"
#include "sensor/SensorsManager.hpp"

void setup() {
  Logger::setup();
  SensorsManager::setup();
}

void loop() {
  auto data = SensorsManager::poll();
  DataUtils::print(data);

  delay(1000);
}