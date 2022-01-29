#pragma once

#include "../AnalogSensor.hpp"
#include "../VoltageDivider.hpp"

class LightSensor : public AnalogSensor {
  VoltageDivider divider;

  uint8_t pin() override { return 33; };

  double voltage2Value(const double voltage) override {
    divider.Vout(voltage);
    const auto Rphotoresistor = divider.Rlower();

    return 10000000 / Rphotoresistor;
  };

 public:
  LightSensor() {
    divider.Roffset(496);
    divider.Rupper(10200);
    divider.Vin(3.3);
  }
};