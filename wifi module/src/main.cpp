
#include "Bridge.hpp"
#include "DataJson.hpp"
#include "DataUtils.hpp"
#include "ExceptionHandler.hpp"
#include "LittleFS.h"
#include "Logger.hpp"
#include "MQTT.hpp"
#include "SoftwareSerial.h"
#include "Time.hpp"
#include "Wifi.hpp"

#define MS "Main setup: "

void serverConnectionScenarioSetup() {
  Logger::setup();
  Wifi::setup();
  Time::syncTime();
  MQTT::setup();
  MQTT::connect();
};

void setup() {
  Logger::setup();
  Logger::debugln(F(D MS "ESP8266 SETUPING"));

  auto exc = Bridge::setup();

  if (exc) ExceptionHandler::handle(exc);

  Logger::debugln(F(D MS "ESP8266 IS SETUPED"));
};

void loop() {
  delay(100);

  if (!Bridge::isSetuped()) {
    const auto exc = Bridge::setup();
    if (exc) return ExceptionHandler::handle(exc);
  }

  const auto str = Bridge::read();

  if (str.isEmpty()) return;

  Logger::debugln(String(D "Input str: ") + str);

  DataDto data;
  const auto exc = DataJson::deserialize(str, data);

  if (exc) return ExceptionHandler::handle(exc);

  DataUtils::print(data);
};
