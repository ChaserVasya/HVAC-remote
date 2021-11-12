#pragma once

#include <Arduino.h>

using namespace std;

class Logger
{
public:
    static bool verbose;

    static void init();

    static void println(const char *);
    static void println();
    static void print(const char *);

    static void info(const char *);
    static void warn(const char *);
    static void error(const char *);

    // Mapping overloads

    static void info(String);
    static void warn(String);
    static void error(String);
};
