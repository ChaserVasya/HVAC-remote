#pragma once

#include <Arduino.h>

#include "AnalogSensor.hpp"

class LightSensor : public AnalogSensor {
  uint8_t pin() override { return A0; };

  double ADC2Value(const int ADCValue) override { return 50000 / ADCValue; };
};