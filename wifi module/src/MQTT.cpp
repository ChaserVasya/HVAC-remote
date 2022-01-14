

#include "MQTT.hpp"

#include "Logger.hpp"
#include "sensitive.hpp"

// TODO GCP IoT JWT lib is not for production. Read about it in lib description.
// Change it.

void MQTT::connect() {
  mqtt->mqttConnect(false);
}  //! if true first attempt will fail

void MQTT::loop() { mqtt->loop(); }

void messageReceivedAdvanced(MQTTClient *client, char topic[], char bytes[],
                             int length) {
  if (length > 0)
    Serial.printf("incoming,0x%s - %s\n", topic, bytes);
  else
    Serial.println("0");
}

String getJwt() {
  ESP.wdtDisable();

  time_t iat = time(nullptr);
  Serial.println("Refreshing JWT");
  String jwt = MQTT::device->createJWT(iat, jwt_exp_secs);

  ESP.wdtEnable(0);

  return jwt;
}

/// INIT ///

MQTTClient *MQTT::mqttClient = nullptr;
WiFiClientSecure *MQTT::netClient = nullptr;
CloudIoTCoreMqtt *MQTT::mqtt = nullptr;
CloudIoTCoreDevice *MQTT::device = nullptr;

void MQTT::setup() {
  mqttClient = new MQTTClient(1000);
  netClient = new WiFiClientSecure;
  device = new CloudIoTCoreDevice("snappy-provider-295713", "asia-east1",
                                  "mqtt-registry", "controller");

  //! timeout > 1000! Otherwise will not connect
  mqttClient->setOptions(180, false, 5000);

  setupSecurity();

  mqtt = new CloudIoTCoreMqtt(mqttClient, netClient, device);
  mqtt->setUseLts(true);
  mqtt->startMQTTAdvanced();
}

void MQTT::setupSecurity() {
  X509List *certs = new X509List;

  certs->append(gprimaryCrtData, gprimaryCrtSize);
  certs->append(gbackupCrtData, gbackupCrtSize);
  netClient->setTrustAnchors(certs);
  netClient->setSSLVersion(BR_TLS12, BR_TLS12);  // required for GCP IoT

  const PrivateKey key(gprivateKeyData, gprivateKeySize);
  device->setPrivateKey(key.getEC()->x);
}
