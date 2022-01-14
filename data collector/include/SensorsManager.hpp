#pragma once

#include "DataDTO.hpp"
#include "LightSensor.hpp"
#include "TemperatureSensor.hpp"
#include "VoltageSensors.hpp"

class SensorsManager {
  static TemperatureSensor tempSensor;
  static LightSensor lightSensor;
  static UNOBatteryVoltageSensor unoBatteryVoltageSensor;
  static ESPBatteryVoltageSensor espBatteryVoltageSensor;

 public:
  static DataDTO poll() {
    auto data = DataDTO();

    data.illuminance = lightSensor.getValue();
    data.temperature = tempSensor.getValue();
    data.UNOBatteryVoltage = unoBatteryVoltageSensor.getValue();
    data.ESPBatteryVoltage = espBatteryVoltageSensor.getValue();

    return data;
  }
};

TemperatureSensor SensorsManager::tempSensor = TemperatureSensor();
LightSensor SensorsManager::lightSensor = LightSensor();
UNOBatteryVoltageSensor SensorsManager::unoBatteryVoltageSensor = UNOBatteryVoltageSensor();
ESPBatteryVoltageSensor SensorsManager::espBatteryVoltageSensor = ESPBatteryVoltageSensor();