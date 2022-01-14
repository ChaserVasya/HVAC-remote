#include <Arduino.h>

#include "Bridge.hpp"
#include "DataUtils.hpp"
#include "ExceptionHandler.hpp"
#include "Exceptions.hpp"
#include "Json.hpp"
#include "Logger.hpp"
#include "SensorsManager.hpp"

#define MS "Main setup: "

void setup() {
  Logger::setup();
  Logger::debugln(F(D MS "UNO SETUPING"));

  Bridge::setup();

  Logger::debugln(F(D MS "UNO IS SETUPED"));
};

void loop() {
  delay(5000);

  try {
    const auto data = SensorsManager::poll();
    Bridge::send(data);
  } catch (const Exception& e) {
    ExceptionHandler::handle(e);
  }
}
