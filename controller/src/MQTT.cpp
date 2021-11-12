

#include "MQTT.hpp"
#include "Logger.hpp"
#include "config.hpp"
//TODO GCP IoT JWT lib is not for production. Read about it in lib description. Change it.

const char *primary_ca =
    "-----BEGIN CERTIFICATE-----\n"
    "MIIDDDCCArKgAwIBAgIUXIRd61ARosjr5tpYAQK1udlptnswCgYIKoZIzj0EAwIw\n"
    "RDELMAkGA1UEBhMCVVMxIjAgBgNVBAoTGUdvb2dsZSBUcnVzdCBTZXJ2aWNlcyBM\n"
    "TEMxETAPBgNVBAMTCEdUUyBMVFNYMB4XDTIxMDUyNTAwMDAwMFoXDTIyMDUyNDAw\n"
    "MDAwMFowbTELMAkGA1UEBhMCVVMxEzARBgNVBAgMCkNhbGlmb3JuaWExFjAUBgNV\n"
    "BAcMDU1vdW50YWluIFZpZXcxEzARBgNVBAoMCkdvb2dsZSBMTEMxHDAaBgNVBAMM\n"
    "EyouMjAzMC5sdHNhcGlzLmdvb2cwWTATBgcqhkjOPQIBBggqhkjOPQMBBwNCAARR\n"
    "VX2FBT6/ZCFlCwom7Pr7jtlh99RHfH0cxO51PZ0gifi8mo2UasKfsw0ikuZvaEkG\n"
    "busnKgGwa6TrBElBabLNo4IBVzCCAVMwEwYDVR0lBAwwCgYIKwYBBQUHAwEwDgYD\n"
    "VR0PAQH/BAQDAgeAMB4GA1UdEQQXMBWCEyouMjAzMC5sdHNhcGlzLmdvb2cwDAYD\n"
    "VR0TAQH/BAIwADAfBgNVHSMEGDAWgBSzK6ugSBx+E4rJCMRAQiKiNlHiCjBpBggr\n"
    "BgEFBQcBAQRdMFswLwYIKwYBBQUHMAKGI2h0dHA6Ly9wa2kuZ29vZy9ndHNsdHNy\n"
    "L2d0c2x0c3guY3J0MCgGCCsGAQUFBzABhhxodHRwOi8vb2NzcC5wa2kuZ29vZy9H\n"
    "VFNMVFNYMCEGA1UdIAQaMBgwDAYKKwYBBAHWeQIFAzAIBgZngQwBAgIwMAYDVR0f\n"
    "BCkwJzAloCOgIYYfaHR0cDovL2NybC5wa2kuZ29vZy9HVFNMVFNYLmNybDAdBgNV\n"
    "HQ4EFgQUxp0CLjzIieJCqFTXjDc9okXUP80wCgYIKoZIzj0EAwIDSAAwRQIgAIuJ\n"
    "1QvJqFZwy6sZCP1+dXOX4YTWAbum6FtqyJwOKIACIQDENBALkXPS9jo0g8X5+eT9\n"
    "MlOQcPMMtbXGtK/ENpE2rw==\n"
    "-----END CERTIFICATE-----\n";

const char *backup_ca =
    "-----BEGIN CERTIFICATE-----\n"
    "MIIC0TCCAnagAwIBAgINAfQKmcm3qFVwT0+3nTAKBggqhkjOPQQDAjBEMQswCQYD\n"
    "VQQGEwJVUzEiMCAGA1UEChMZR29vZ2xlIFRydXN0IFNlcnZpY2VzIExMQzERMA8G\n"
    "A1UEAxMIR1RTIExUU1IwHhcNMTkwMTIzMDAwMDQyWhcNMjkwNDAxMDAwMDQyWjBE\n"
    "MQswCQYDVQQGEwJVUzEiMCAGA1UEChMZR29vZ2xlIFRydXN0IFNlcnZpY2VzIExM\n"
    "QzERMA8GA1UEAxMIR1RTIExUU1gwWTATBgcqhkjOPQIBBggqhkjOPQMBBwNCAARr\n"
    "6/PTsGoOg9fXhJkj3CAk6C6DxHPnZ1I+ER40vEe290xgTp0gVplokojbN3pFx07f\n"
    "zYGYAX5EK7gDQYuhpQGIo4IBSzCCAUcwDgYDVR0PAQH/BAQDAgGGMB0GA1UdJQQW\n"
    "MBQGCCsGAQUFBwMBBggrBgEFBQcDAjASBgNVHRMBAf8ECDAGAQH/AgEAMB0GA1Ud\n"
    "DgQWBBSzK6ugSBx+E4rJCMRAQiKiNlHiCjAfBgNVHSMEGDAWgBQ+/v/MUuu/ND49\n"
    "80DQ5CWxX7i7UjBpBggrBgEFBQcBAQRdMFswKAYIKwYBBQUHMAGGHGh0dHA6Ly9v\n"
    "Y3NwLnBraS5nb29nL2d0c2x0c3IwLwYIKwYBBQUHMAKGI2h0dHA6Ly9wa2kuZ29v\n"
    "Zy9ndHNsdHNyL2d0c2x0c3IuY3J0MDgGA1UdHwQxMC8wLaAroCmGJ2h0dHA6Ly9j\n"
    "cmwucGtpLmdvb2cvZ3RzbHRzci9ndHNsdHNyLmNybDAdBgNVHSAEFjAUMAgGBmeB\n"
    "DAECATAIBgZngQwBAgIwCgYIKoZIzj0EAwIDSQAwRgIhAPWeg2v4yeimG+lzmZAC\n"
    "DJOlalpsiwJR0VOeapY8/7aQAiEAiwRsSQXUmfVUW+N643GgvuMH70o2Agz8w67f\n"
    "SX+k+Lc=\n"
    "-----END CERTIFICATE-----\n";

void MQTT::connect()
{
    mqtt->mqttConnect();
}

void MQTT::loop()
{
    mqtt->loop();
}

/// INIT ///

void MQTT::setupCertsAndKey()
{

    certs->append(primary_ca);
    certs->append(backup_ca);
    // certs->append(gprimaryCrtData, gprimaryCrtSize);
    // certs->append(gbackupCrtData, gbackupCrtSize);
    netClient->setTrustAnchors(certs);

    const PrivateKey key(gprivateKeyData, gprivateKeySize);

    device->setPrivateKey(key.getEC()->x);
}

void MQTT::init()
{
    Logger::info("MQTT initing");

    netClient = new WiFiClientSecure();
    certs = new X509List();
    mqttClient = new MQTTClient(512);
    mqttClient->setOptions(180, true, 1000); // keepAlive, cleanSession, timeout
    device = new CloudIoTCoreDevice(
        "snappy-provider-295713",
        "asia-east1",
        "mqtt-registry",
        "controller");

    setupCertsAndKey();

    mqtt = new CloudIoTCoreMqtt(mqttClient, netClient, device);
    mqtt->setUseLts(true);
    mqtt->startMQTTAdvanced();

    Logger::info("MQTT inited");
}

CloudIoTCoreDevice *MQTT::device = nullptr;
WiFiClientSecure *MQTT::netClient = nullptr;
MQTTClient *MQTT::mqttClient = nullptr;
CloudIoTCoreMqtt *MQTT::mqtt = nullptr;
X509List *MQTT::certs = nullptr;

const char *MQTT::mqtt_server = "mqtt.2030.ltsapis.goog";
const int MQTT::port = 8883;
const char *MQTT::topic = "/devices/controller/events";

void messageReceivedAdvanced(MQTTClient *client, char topic[], char bytes[], int length)
{
    if (length > 0)
    {
        Serial.printf("incoming: %s - %s\n", topic, bytes);
    }
    else
    {
        Serial.printf("0\n"); // Success but no message
    }
}

String getJwt()
{
    // Disable software watchdog as these operations can take a while.
    ESP.wdtDisable();
    time_t iat = time(nullptr);
    Serial.println("Refreshing JWT");
    Serial.println(iat);
    String jwt = MQTT::device->createJWT(1636696991, jwt_exp_secs);
    ESP.wdtEnable(0);
    Logger::info(jwt);
    return jwt;
}
