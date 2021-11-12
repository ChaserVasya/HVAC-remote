#include "Logger.hpp"

bool Logger::verbose = true;

void Logger::init()
{
    Serial.begin(9600);
    Serial.println();
    info("Logger inited");
}

void Logger::println()
{
    if (verbose)
        Serial.println();
}

void Logger::println(const char *str)
{
    if (verbose)
        Serial.println(str);
}

void Logger::print(const char *str)
{
    if (verbose)
        Serial.print(str);
}

void Logger::info(const char *str)
{
    println(str);
}

void Logger::warn(const char *str)
{
    println(str);
}

void Logger::error(const char *str)
{
    println(str);
}

// Mapping overloads

void Logger::info(String str)
{

    info(str.c_str());
}
void Logger::warn(String str)
{
    warn(str.c_str());
}
void Logger::error(String str)
{
    error(str.c_str());
}