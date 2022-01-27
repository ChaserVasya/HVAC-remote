#pragma once

#include <Arduino.h>

// ESP32 has bad ADC with truncated range
// upper lim: 3.121V
// lower lim: 0.112V
class AnalogSensor {
  virtual uint8_t pin() = 0;
  virtual double voltage2Value(const double voltage) = 0;

  uint32_t getAntiAliasingFilteredVoltage() {
    constexpr uint16_t samplesQuantity = 1000;
    uint64_t accumulator = 0;

    for (uint16_t i = 0; i < samplesQuantity; i++) accumulator += analogReadMilliVolts(pin());
    uint32_t mean = accumulator / samplesQuantity;
    return mean;
  }

  /*
  [analogReadMilliVolts] is a first compensation step.
  This method is the latest user defined adjustment.
  */
  uint32_t compensateADCErrors(uint32_t mV) {
    constexpr int8_t constOffset = -30;

    mV += constOffset;
    if (mV > 2000) mV += (1 / 40.0) * mV - 50;

    return mV;
  }

 public:
  double getValue() { return voltage2Value(getVoltage()); }

  double getVoltage() {
    uint32_t mV;
    mV = getAntiAliasingFilteredVoltage();
    mV = compensateADCErrors(mV);

    return mV / 1000.0;
  }
};