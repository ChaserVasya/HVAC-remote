#pragma once

#include "domain/DataDTO.hpp"
#include "sensors/BatteryVoltageSensor.hpp"
#include "sensors/LightSensor.hpp"
#include "sensors/TemperatureSensor.hpp"

class SensorsManager {
  static TemperatureSensor tempSensor;
  static LightSensor lightSensor;
  static BatteryVoltageSensor batteryVoltageSensor;

 public:
  static void setup() { analogSetAttenuation(ADC_11db); }

  static DataDTO poll() {
    auto data = DataDTO();

    data.illuminance = lightSensor.getValue();
    data.temperature = tempSensor.getValue();
    data.batteryVoltage = batteryVoltageSensor.getValue();

    return data;
  }
};

TemperatureSensor SensorsManager::tempSensor = TemperatureSensor();
LightSensor SensorsManager::lightSensor = LightSensor();
BatteryVoltageSensor SensorsManager::batteryVoltageSensor = BatteryVoltageSensor();
