#pragma once

#include "ESP8266WiFi.h"
#include "WiFiClientSecureBearSSL.h"
#include <CloudIoTCoreMqtt.h>

class MQTT
{
    static const char *mqtt_server;
    const static int port;
    const static char *topic;
    const static char *name;

    static WiFiClientSecure *netClient;
    static MQTTClient *mqttClient;
    static CloudIoTCoreMqtt *mqtt;
    static X509List *certs;

    static void setupKey();
    static void setupCertsAndKey();

public:
    static CloudIoTCoreDevice *device;

    static void init();

    static void connect();
    static void loop();
};