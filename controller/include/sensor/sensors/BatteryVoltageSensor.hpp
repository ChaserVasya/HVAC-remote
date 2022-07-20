#pragma once

#include "../AnalogSensor.hpp"
#include "../VoltageDivider.hpp"

class BatteryVoltageSensor : public AnalogSensor {
  uint8_t pin() override { return 34; };

  VoltageDivider divider;

  double voltage2Value(const double voltage) override {
    divider.Vout(voltage);
    return divider.Vin();
  };

 public:
  BatteryVoltageSensor() {
    divider.Rupper(46400);
    divider.Rlower(14640);
  }
};
