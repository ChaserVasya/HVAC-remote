#pragma once

#include <Arduino.h>

// ESP32 has bad ADC:
// - upper lim: 3.121V
// - lower lim: 0.112V
// - big noise
// - non-linear dependency on Vin
//
// nonlinearity is compensated by using special ESP
// function [analogReadMilliVolts()] and [analogSetAttenuation()] (in SensorManager).
// [analogReadMilliVolts()] maps input ADC to right millivolts.
// I also define my-own [userDefinedCorrection] to improve accuracy
// based on personal observations.
//
// big noise is neutralizes by [getAntiAliasingFilteredVoltage]
//
// bad limits resolved by derived classes. Probably by [VoltageDelimiter] usages
class AnalogSensor {
  virtual uint8_t pin() = 0;
  virtual double voltage2Value(const double voltage) = 0;

  // neutralizes noise
  uint32_t getAntiAliasingFilteredVoltage() {
    constexpr uint16_t samplesQuantity = 1000;
    uint64_t accumulator = 0;

    for (uint16_t i = 0; i < samplesQuantity; i++) accumulator += analogReadMilliVolts(pin());
    uint32_t mean = accumulator / samplesQuantity;
    return mean;
  }

  uint32_t userDefinedCorrection(uint32_t mV) {
    constexpr int8_t constOffset = -30;

    mV += constOffset;
    if (mV > 2000) mV += (1 / 40.0) * mV - 50;

    return mV;
  }

 public:
  // high-level function. Returns final values like lux, celsium, voltage.
  double getValue() { return voltage2Value(getVoltage()); }

  // hides all ESP32 ADC problems
  double getVoltage() {
    uint32_t mV;
    mV = getAntiAliasingFilteredVoltage();
    mV = userDefinedCorrection(mV);

    return mV / 1000.0;
  }
};