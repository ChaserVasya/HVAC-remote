#include "communication/MQTT/Yandex.hpp"

#include "common/Logger.hpp"
#include "exception/Exceptions.hpp"

extern const uint8_t deviceCert[] asm("_binary_src_communication_sensitive_yandex_cert_pem_start");
extern const uint8_t privateKey[] asm("_binary_src_communication_sensitive_yandex_key_pem_start");
extern const uint8_t rootCA[] asm("_binary_src_communication_sensitive_yandex_root_ca_crt_start");

void YandexMQTT::connect() {
  log_i("Connecting...");

  const uint8_t maxAttempts = 5;
  uint8_t attemptNumber = 0;

  while (true) {
    if (++attemptNumber > maxAttempts) throw MQTTException(1);

    bool connected = mqttClient->connect(cliendID, username, password);

    if (!connected) {
      logError();
      logReturnCode();

      mqttClient->disconnect();
      log_d("Delaying 5000 ms");
      delay(5000);
      log_e("Not connected");

      continue;
    }

    log_d("Connected");

    return;
  }
}

void YandexMQTT::loop() { mqttClient->loop(); }

void YandexMQTT::send(String serialized) { mqttClient->publish(topic, serialized); }
void YandexMQTT::send(String subtopic, String serialized) { mqttClient->publish(topic + subtopic, serialized); }

void onMessageAdvanced(MQTTClient *client, char topic[], char bytes[], int length) {
  if (length > 0)
    log_i("incoming,0x%s - %s\n", topic, bytes);
  else
    log_i("0");
}

/// INIT ///

void YandexMQTT::setup() {
  setupSecurity();

  const char *hostName = "mqtt.cloud.yandex.net";
  const int port = 8883;
  mqttClient->setOptions(180, true, 10000);
  mqttClient->begin(hostName, port, *netClient);
  mqttClient->onMessageAdvanced(onMessageAdvanced);
}

void YandexMQTT::setupSecurity() {
  netClient->setCACert((const char *)rootCA);
  netClient->setCertificate((const char *)deviceCert);
  netClient->setPrivateKey((const char *)privateKey);
}

/// ERRORS ///

void YandexMQTT::logError() {
  switch (mqttClient->lastError()) {
    case (LWMQTT_BUFFER_TOO_SHORT):
      log_e("LWMQTT_BUFFER_TOO_SHORT");
      break;
    case (LWMQTT_VARNUM_OVERFLOW):
      log_e("LWMQTT_VARNUM_OVERFLOW");
      break;
    case (LWMQTT_NETWORK_FAILED_CONNECT):
      log_e("LWMQTT_NETWORK_FAILED_CONNECT");
      break;
    case (LWMQTT_NETWORK_TIMEOUT):
      log_e("LWMQTT_NETWORK_TIMEOUT");
      break;
    case (LWMQTT_NETWORK_FAILED_READ):
      log_e("LWMQTT_NETWORK_FAILED_READ");
      break;
    case (LWMQTT_NETWORK_FAILED_WRITE):
      log_e("LWMQTT_NETWORK_FAILED_WRITE");
      break;
    case (LWMQTT_REMAINING_LENGTH_OVERFLOW):
      log_e("LWMQTT_REMAINING_LENGTH_OVERFLOW");
      break;
    case (LWMQTT_REMAINING_LENGTH_MISMATCH):
      log_e("LWMQTT_REMAINING_LENGTH_MISMATCH");
      break;
    case (LWMQTT_MISSING_OR_WRONG_PACKET):
      log_e("LWMQTT_MISSING_OR_WRONG_PACKET");
      break;
    case (LWMQTT_CONNECTION_DENIED):
      log_e("LWMQTT_CONNECTION_DENIED");
      break;
    case (LWMQTT_FAILED_SUBSCRIPTION):
      log_e("LWMQTT_FAILED_SUBSCRIPTION");
      break;
    case (LWMQTT_SUBACK_ARRAY_OVERFLOW):
      log_e("LWMQTT_SUBACK_ARRAY_OVERFLOW");
      break;
    case (LWMQTT_PONG_TIMEOUT):
      log_e("LWMQTT_PONG_TIMEOUT");
      break;
    default:
      log_e("This error code should never be reached.");
      break;
  }
}

void YandexMQTT::logReturnCode() {
  switch (mqttClient->returnCode()) {
    case (LWMQTT_CONNECTION_ACCEPTED):
      log_e("OK");
      break;
    case (LWMQTT_UNACCEPTABLE_PROTOCOL):
      log_e("LWMQTT_UNACCEPTABLE_PROTOCOLL");
      break;
    case (LWMQTT_IDENTIFIER_REJECTED):
      log_e("LWMQTT_IDENTIFIER_REJECTED");
      break;
    case (LWMQTT_SERVER_UNAVAILABLE):
      log_e("LWMQTT_SERVER_UNAVAILABLE");
      break;
    case (LWMQTT_BAD_USERNAME_OR_PASSWORD):
      log_e("LWMQTT_BAD_USERNAME_OR_PASSWORD");
      break;
    case (LWMQTT_NOT_AUTHORIZED):
      log_e("LWMQTT_NOT_AUTHORIZED");
      break;
    case (LWMQTT_UNKNOWN_RETURN_CODE):
      log_e("LWMQTT_UNKNOWN_RETURN_CODE");
      break;
    default:
      log_e("This return code should never be reached.");
      break;
  }
}
