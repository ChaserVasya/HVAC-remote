#include <Arduino.h>

#include "Bridge.hpp"
#include "DataJson.hpp"
#include "DataUtils.hpp"
#include "ExceptionHandler.hpp"
#include "Exceptions.hpp"
#include "Logger.hpp"
#include "SensorsManager.hpp"

#define MS "Main setup: "

void setup() {
  Logger::setup();
  Logger::debugln(F(D MS "UNO SETUPING"));

  const auto exc = Bridge::setup();

  if (exc) ExceptionHandler::handle(exc);

  Logger::debugln(F(D MS "UNO IS SETUPED"));
};

void loop() {
  delay(5000);

  BridgeException exc;

  if (Bridge::isSetuped()) {
    const auto data = SensorsManager::poll();
    const auto json = DataJson::serialize(data);
    exc = Bridge::send(json);
  } else {
    exc = Bridge::setup();
  }
  if (exc) ExceptionHandler::handle(exc);
}
