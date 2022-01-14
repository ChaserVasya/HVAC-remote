#pragma once

#include <Arduino.h>

#include "AnalogSensor.hpp"

class TemperatureSensor : public AnalogSensor {
  uint8_t pin() override { return A1; };

  // double ADC2Value(int ADCValue) override { return ADCValue * (500.0 / 1024);
  // };

  double ADC2Value(int ADCValue) override {
    return (ADCValue * 5.0 / 1024) / 0.01;
  };
};