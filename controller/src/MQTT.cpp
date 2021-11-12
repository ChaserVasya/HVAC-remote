

#include "MQTT.hpp"
#include "Logger.hpp"
#include "config.hpp"
//TODO GCP IoT JWT lib is not for production. Read about it in lib description. Change it.

#if false //files
const char *primary_ca = "-----BEGIN CERTIFICATE-----\n"
                         "MIIBxTCCAWugAwIBAgINAfD3nVndblD3QnNxUDAKBggqhkjOPQQDAjBEMQswCQYD\n"
                         "VQQGEwJVUzEiMCAGA1UEChMZR29vZ2xlIFRydXN0IFNlcnZpY2VzIExMQzERMA8G\n"
                         "A1UEAxMIR1RTIExUU1IwHhcNMTgxMTAxMDAwMDQyWhcNNDIxMTAxMDAwMDQyWjBE\n"
                         "MQswCQYDVQQGEwJVUzEiMCAGA1UEChMZR29vZ2xlIFRydXN0IFNlcnZpY2VzIExM\n"
                         "QzERMA8GA1UEAxMIR1RTIExUU1IwWTATBgcqhkjOPQIBBggqhkjOPQMBBwNCAATN\n"
                         "8YyO2u+yCQoZdwAkUNv5c3dokfULfrA6QJgFV2XMuENtQZIG5HUOS6jFn8f0ySlV\n"
                         "eORCxqFyjDJyRn86d+Iko0IwQDAOBgNVHQ8BAf8EBAMCAYYwDwYDVR0TAQH/BAUw\n"
                         "AwEB/zAdBgNVHQ4EFgQUPv7/zFLrvzQ+PfNA0OQlsV+4u1IwCgYIKoZIzj0EAwID\n"
                         "SAAwRQIhAPKuf/VtBHqGw3TUwUIq7TfaExp3bH7bjCBmVXJupT9FAiBr0SmCtsuk\n"
                         "miGgpajjf/gFigGM34F9021bCWs1MbL0SA==\n"
                         "-----END CERTIFICATE-----\n";

const char *backup_ca = "-----BEGIN CERTIFICATE-----\n"
                        "MIIB4TCCAYegAwIBAgIRKjikHJYKBN5CsiilC+g0mAIwCgYIKoZIzj0EAwIwUDEk\n"
                        "MCIGA1UECxMbR2xvYmFsU2lnbiBFQ0MgUm9vdCBDQSAtIFI0MRMwEQYDVQQKEwpH\n"
                        "bG9iYWxTaWduMRMwEQYDVQQDEwpHbG9iYWxTaWduMB4XDTEyMTExMzAwMDAwMFoX\n"
                        "DTM4MDExOTAzMTQwN1owUDEkMCIGA1UECxMbR2xvYmFsU2lnbiBFQ0MgUm9vdCBD\n"
                        "QSAtIFI0MRMwEQYDVQQKEwpHbG9iYWxTaWduMRMwEQYDVQQDEwpHbG9iYWxTaWdu\n"
                        "MFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAEuMZ5049sJQ6fLjkZHAOkrprlOQcJ\n"
                        "FspjsbmG+IpXwVfOQvpzofdlQv8ewQCybnMO/8ch5RikqtlxP6jUuc6MHaNCMEAw\n"
                        "DgYDVR0PAQH/BAQDAgEGMA8GA1UdEwEB/wQFMAMBAf8wHQYDVR0OBBYEFFSwe61F\n"
                        "uOJAf/sKbvu+M8k8o4TVMAoGCCqGSM49BAMCA0gAMEUCIQDckqGgE6bPA7DmxCGX\n"
                        "kPoUVy0D7O48027KqGx2vKLeuwIgJ6iFJzWbVsaj8kfSt24bAgAXqmemFZHe+pTs\n"
                        "ewv4n4Q=\n"
                        "-----END CERTIFICATE-----\n";
#else     //openssl connect
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
#endif

const char *privc =
    "-----BEGIN EC PRIVATE KEY-----\n"
    "MHcCAQEEIBjVYlpJmz81qEJ/YIiIYlkeLshb349ZhNmcte754IikoAoGCCqGSM49\n"
    "AwEHoUQDQgAE8CHzyYE+JvmpDAJt8aW2euC8ZT7EsaqS4emigerI5ZQolKgpx/EQ\n"
    "Ze90BE5IecYPUa5GGc+nykvn/lCEl59CFg==\n"
    "-----END EC PRIVATE KEY-----\n";

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
    // netClient->setInsecure();

    certs->append(primary_ca);
    certs->append(backup_ca);
    // certs->append(gprimaryCrtData, gprimaryCrtSize);
    // certs->append(gbackupCrtData, gbackupCrtSize);
    netClient->setTrustAnchors(certs);

    netClient->setInsecure();

    const PrivateKey key(gprivateKeyData, gprivateKeySize);
    // const PrivateKey key(privc);
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

    char buf[256];
    auto code = MQTT::netClient->getLastSSLError(buf, 256);
    if (code != 0)
    {
        Serial.print("Last SSL ERROR was: ");
        Serial.print(code);
        Serial.print(" - ");
        Serial.println(buf);
    }

    // Disable software watchdog as these operations can take a while.
    ESP.wdtDisable();
    time_t iat = time(nullptr);
    Serial.println("Refreshing JWT");
    String jwt = MQTT::device->createJWT(1636722571, jwt_exp_secs);
    Serial.println(jwt);
    ESP.wdtEnable(0);
    return jwt;
}
