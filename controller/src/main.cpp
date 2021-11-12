
#include "WiFiFacade.hpp"
#include "MQTT.hpp"
#include "Logger.hpp"

void setup()
{
  Logger::init();
  WiFiFacade::connect();
  MQTT::init();
  MQTT::connect();
}

void loop()
{
  MQTT::loop();
}

// LittleFS.begin();
// File file = LittleFS.open("backup.crt", "r");
// size_t size = file.size();
