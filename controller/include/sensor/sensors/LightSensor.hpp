#pragma once

#include "../AnalogSensor.hpp"
#include "../VoltageDivider.hpp"

class LightSensor : public AnalogSensor {
  VoltageDivider divider;

  uint8_t pin() override { return 35; };

  double voltage2Value(const double voltage) override {
    uint32_t empiricalSelectedFactor = 10000000;

    divider.Vout(voltage);
    const auto Rphotoresistor = divider.Rlower();

    return empiricalSelectedFactor / Rphotoresistor;
  };

 public:
  LightSensor() {
    divider.Roffset(496);
    divider.Rupper(10200);
    divider.Vin(3.3);
  }
};