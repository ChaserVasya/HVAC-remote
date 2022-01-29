

#include "communication/MQTT.hpp"

#include "common/Logger.hpp"
#include "communication/sensitive.hpp"

extern const uint8_t primaryCert[] asm("_binary_src_communication_sensitive_primary_cer_start");
extern const uint8_t backupCert[] asm("_binary_src_communication_sensitive_backup_cer_start");

// TODO GCP IoT JWT lib is not for production. Read about it in lib description.
// Change it.

void MQTT::connect() { mqtt->mqttConnect(false); }  //! if true first attempt will fail

void MQTT::loop() { mqtt->loop(); }

void MQTT::send(String serialized) { mqtt->publishTelemetry(serialized); }

void messageReceivedAdvanced(MQTTClient *client, char topic[], char bytes[], int length) {
  if (length > 0)
    Serial.printf("incoming,0x%s - %s\n", topic, bytes);
  else
    Serial.println("0");
}

String getJwt() {
  time_t iat = time(nullptr);
  Serial.println("Refreshing JWT");
  String jwt = MQTT::device->createJWT(iat, jwt_exp_secs);

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
  device = new CloudIoTCoreDevice("snappy-provider-295713", "asia-east1", "mqtt-registry", "controller");

  //! timeout > 1000! Otherwise will not connect
  mqttClient->setOptions(180, false, 5000);

  setupSecurity();

  mqtt = new CloudIoTCoreMqtt(mqttClient, netClient, device);
  mqtt->setUseLts(true);
  mqtt->startMQTTAdvanced();
}

void MQTT::setupSecurity() {
  String certs;
  certs += (const char *)primaryCert;
  certs += (const char *)backupCert;
  netClient->setCACert(certs.c_str());
  device->setPrivateKey(privateKey);
}
