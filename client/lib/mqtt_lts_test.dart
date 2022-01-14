import 'dart:async';

import 'package:jose/jose.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:test/test.dart';
import 'package:typed_data/typed_data.dart';

import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart' show rootBundle;

class MqttDb {
  final _GoogleMqttConfiguration _conf = _GoogleMqttConfiguration();

  Future<void> connect() async {
    await _conf.init;
    final password = _createJWTforGoogleIot();
    final _client = _conf.client;
    await _client.connect(_conf.username, password);

    for (int i = 1; i < 20; i++) {
      await Future.delayed(Duration(seconds: 1));
      print(i);
    }
    _client.disconnect();
  }

  Future<void> send(Uint8Buffer payload) async {
    await _conf.init;
    final password = _createJWTforGoogleIot();
    final _client = _conf.client;
    // final subtopic = endpoint.toString().split('.').last;
    await _client.connect(_conf.username, password);
    // _client.publishMessage(_conf.upperPathForSend + subtopic, _conf.qosLevel, payload);
    _client.disconnect();
  }

  String _createJWTforGoogleIot() {
    const secondsPerDay = 86400;
    const millisecondsPerSecond = 1000;

    final claims = JsonWebTokenClaims.fromJson(
      {
        "aud": _conf.projectID,
        "iat": (DateTime.now().millisecondsSinceEpoch) ~/ millisecondsPerSecond, //unix time
        "exp": ((DateTime.now().millisecondsSinceEpoch) ~/ millisecondsPerSecond) + secondsPerDay,
      },
    );
    final builder = JsonWebSignatureBuilder();
    builder.jsonContent = claims.toJson();
    builder.addRecipient(_conf.key, algorithm: 'ES256');
    final jwt = builder.build().toCompactSerialization();
    return jwt;
  }
}

class _MqttCallBacksDecorator {
  int _subCounter = 0;
  int _disCounter = 0;
  int _conCounter = 0;

  _MqttCallBacksDecorator();
  MqttServerClient addCallbacks(MqttServerClient client) {
    bool Function(dynamic)? _onBadCertificate = (_) {
      _printWithFrame('BAD CERTIFICATE');
      return true;
    };

    void _onUnsubscribed(String? text) => _printWithFrame('UNSUBSCRIBED:  $text');
    void _onSubscribeFail(String text) => _printWithFrame('SUBSCRIBING FAILED:  $text');
    void _onConnected() => _printWithFrame('${_conCounter++}CONNECTED');
    void _onDisconnected() => _printWithFrame('${_disCounter++}DISCONNECTED');
    void _onAutoReconnect() => _printWithFrame('AUTORECONNECT');
    void _onSubscribed(String text) => _printWithFrame('${_subCounter++}SUBSCRIBED: $text');

    client
      ..onDisconnected = _onDisconnected
      ..onConnected = _onConnected
      ..onSubscribeFail = _onSubscribeFail
      ..onUnsubscribed = _onUnsubscribed
      ..onAutoReconnect = _onAutoReconnect
      ..onBadCertificate = _onBadCertificate
      ..onSubscribed = _onSubscribed;
    return client;
  }

  // Those callbacks are taken out of addCallbacks method
  // because MqttServerClient can add those callbacks only in
  // MqttServerClient.updates.listen method like argument
  void onDone() => _printWithFrame('DONE');
  void onError(Object obj) => _printWithFrame('ERROR : $obj');

  void _printWithFrame(String text) {
    String equals = '============';
    print('$equals $text $equals');
  }
}

class _GoogleMqttConfiguration {
  late Future<void> init;

  late final MqttServerClient client;
  late final JsonWebKey key;

  late final SecurityContext securityContext;
  late final _MqttCallBacksDecorator mqttCallbacks;

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

  _GoogleMqttConfiguration({
    this.projectID = 'snappy-provider-295713',
    this.deviceID = 'controller',
    this.location = 'asia-east1',
    this.registryID = 'mqtt-registry',
    this.username = 'unused',
    this.url = "mqtt.2030.ltsapis.goog",
    this.port = 8883,
    this.qosLevel = MqttQos.atMostOnce,
    this.logsAreNeeded = true,
    this.rootsFileAddress = 'assets/roots/roots.pem',
    this.keyFileAddress = 'assets/keys/app_private.pem',
  })  : mqttCallbacks = _MqttCallBacksDecorator(),
        clientID =
            'projects/$projectID/locations/$location/registries/$registryID/devices/$deviceID',
        upperPathForSend = '/devices/$deviceID/events/',
        upperPathForReceive = '/devices/$deviceID/',
        securityContext = SecurityContext.defaultContext {
    final untunedClient = MqttServerClient(url, clientID)
      ..port = port
      ..secure = true
      ..setProtocolV311()
      ..logging(on: logsAreNeeded);
    client = mqttCallbacks.addCallbacks(untunedClient);

    Future<void> _init() async {
      key = JsonWebKey.fromPem(await rootBundle.loadString('assets/sensitive/private.pem'));
      // securityContext.setTrustedCertificatesBytes(
      //     utf8.encode(await rootBundle.loadString('assets/sensitive/primary.pem')));
      // securityContext.setTrustedCertificatesBytes(
      //     utf8.encode(await rootBundle.loadString('assets/sensitive/backup.pem')));

      // securityContext.setTrustedCertificates('assets/sensitive/primary.pem');
      // securityContext.setTrustedCertificates('assets/sensitive/backup.pem');
      client.securityContext = securityContext;
    }

    init = _init();
  }
}
