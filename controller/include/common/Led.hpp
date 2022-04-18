#pragma once

#include <Arduino.h>

// My ESP32 board has strange build-in led.
// It doesn`t need in [digitalWrite].
// I think there is circuit 3.3v-LED-GPIO22-Ground
// When I [pinMode(GPIO22,Output)] GPIO22 resistance
// becames low and LED is on.
class Led {
  static constexpr uint8_t pin = 22;

 public:
  static void powerOn() {
    pinMode(pin, OUTPUT);
    delay(5000);
  }

  static void powerOff() { pinMode(pin, INPUT); }
};