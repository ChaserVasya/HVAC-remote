#pragma once

#include <math.h>

#include "../AnalogSensor.hpp"
#include "../VoltageDivider.hpp"

class TemperatureSensor : public AnalogSensor {
 public:
  TemperatureSensor() {
    divider.Rupper(46000);
    divider.Vin(3.3);
  }

 private:
  VoltageDivider divider;
  uint8_t pin() override { return 32; };

  double voltage2Value(const double voltage) override {
    divider.Vout(voltage);
    const auto Rthermistor = divider.Rlower();
    const auto TKelvin = SteinhartHart_toT(Rthermistor);
    const auto TCelsius = TKelvin - 273.15;
    return TCelsius;
  };

  // Steinhart-Hart - main thermistor dependency T(R)
  // coefs defined by my own methods
  double SteinhartHart_toT(const double R) {
    constexpr auto a = -6.46e-4;
    constexpr auto b = 4.155e-4;
    constexpr auto c = -3.9e-7;

    const auto lnR = log(R);
    const auto T = 1 / (a + (b * lnR) + (c * pow(lnR, 3)));
    return T;
  }
};