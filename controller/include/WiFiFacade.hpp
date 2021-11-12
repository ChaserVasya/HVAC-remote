#pragma once

#include <Arduino.h>

class WiFiFacade
{
    static const String ssid;
    static const String password;

public:
    static void connect();
};
