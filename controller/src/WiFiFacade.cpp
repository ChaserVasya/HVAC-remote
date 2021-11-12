#include "WiFiFacade.hpp"
#include "ESP8266WiFi.h"
#include "Logger.hpp"

const String WiFiFacade::ssid = "TP-Link_2102";
const String WiFiFacade::password = "58098257";

void WiFiFacade::connect()
{
    Logger::info("WiFi connecting start");

    WiFi.begin(ssid, password);

    while (WiFi.status() != WL_CONNECTED)
    {
        delay(500);
        Logger::print(".");
    }
    Logger::println();
    Logger::info("WiFi connected");
    Logger::info(WiFi.localIP().toString());
};
