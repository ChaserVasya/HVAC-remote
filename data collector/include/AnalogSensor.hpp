#pragma once

#include <Arduino.h>

class AnalogSensor {
  virtual uint8_t pin() = 0;
  virtual double ADC2Value(const int ADCValue) = 0;

 public:
  int getADCValue() { return analogRead(pin()); }

  double getValue() {
    getADCValue();  // for s/h curcuit stabilizing
    return ADC2Value(getADCValue());
  }
};