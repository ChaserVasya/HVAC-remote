import 'dart:convert';
import 'dart:io';

import 'package:jose/jose.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:my_mqtt/data/api/mqtt/mqtt_callbacks_decorator.dart';

class GoogleMqttConfiguration {
  late Future<void> init;

  late final MqttServerClient client;
  late final JsonWebKey key;

  late final SecurityContext securityContext;
  late final MqttCallBacksDecorator mqttCallbacks;

  final String rootsFileAddress;
  final String keyFileAddress;

  final String projectID;
  final String location;
  final String registryID;
  final String deviceID;
  final String clientID;

  final String upperPathForSend;
  final String upperPathForReceive;

  final String url;
  final String username;
  final int port; // 8883 or 443
  final MqttQos qosLevel;
  final bool logsAreNeeded;

  GoogleMqttConfiguration({
    this.projectID = 'snappy-provider-295713',
    this.deviceID = 'app',
    this.location = 'asia-east1',
    this.registryID = 'mqtt-registry',
    this.username = 'unused',
    this.url = 'mqtt.googleapis.com',
    this.port = 8883,
    this.qosLevel = MqttQos.atMostOnce,
    this.logsAreNeeded = false,
    this.rootsFileAddress = 'assets/roots/roots.pem',
    this.keyFileAddress = 'assets/keys/app_private.pem',
  })  : mqttCallbacks = MqttCallBacksDecorator(),
        clientID = 'projects/$projectID/locations/$location/registries/$registryID/devices/$deviceID',
        upperPathForSend = '/devices/$deviceID/events/',
        upperPathForReceive = '/devices/$deviceID/',
        securityContext = SecurityContext.defaultContext {
    MqttServerClient untunedClient = MqttServerClient(url, clientID)
      ..port = port
      ..secure = true
      ..setProtocolV311()
      ..logging(on: logsAreNeeded);
    client = mqttCallbacks.addCallbacks(untunedClient);

    Future<void> _init() async {
      key = JsonWebKey.fromPem(await rootBundle.loadString(keyFileAddress));
      securityContext.setClientAuthoritiesBytes(utf8.encode(await rootBundle.loadString(rootsFileAddress)));
      client.securityContext = securityContext;
    }

    init = _init();
  }
}
