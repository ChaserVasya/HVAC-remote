#include "injection.hpp"

#include "communication/MQTT/Interface.hpp"
#include "communication/MQTT/Yandex.hpp"

MQTT* const mqtt = new YandexMQTT;