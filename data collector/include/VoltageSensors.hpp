#pragma once

#include "AnalogSensor.hpp"

class VoltageSensor : public AnalogSensor {
  // voltage divider with equal R
  double ADC2Value(int ADCValue) override {
    return ADCValue * (5.0 / 1024) * 2;
  };
};

class ESPBatteryVoltageSensor : public VoltageSensor {
  uint8_t pin() override { return A3; };
};

class UNOBatteryVoltageSensor : public VoltageSensor {
  uint8_t pin() override { return A2; };
};