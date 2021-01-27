import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:jose/jose.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:my_mqtt/data/model/pid_page_data.dart';

class ApiChannels {
  final _MqttCallBacks _mqttCallbacks = _MqttCallBacks();
  final _GoogleMqttConfiguration _mqttConf = _GoogleMqttConfiguration();
  final SecurityContext _securityContext = SecurityContext.defaultContext;

  final String _rootsFileAddress = 'assets/roots/roots.pem';
  final String _keyFileAddress = 'assets/keys/PrivateKey.pem';

  JsonWebKey _key;
  MqttServerClient _client;

  Future<void> _init;

  static final ApiChannels _apiChannels = ApiChannels._();

  //An instance of this class has a long initialization because of
  //many Future-members.  So, factory improves perfomance because
  //initialization is made once.
  factory ApiChannels() => _apiChannels;

  ApiChannels._() {
    _client = MqttServerClient(_mqttConf.url, _mqttConf.clientID);
    _init = _asynclyLoadFiles().whenComplete(() {
      _client
        ..port = _mqttConf.port
        ..secure = true
        ..securityContext = _securityContext
        ..setProtocolV311()
        ..logging(on: _mqttConf.logsAreNeeded);
      _client = _mqttCallbacks.addCallbacks(_client);
      receiveChannelValues();
    });
  }

  Future<void> _asynclyLoadFiles() async {
    _key = JsonWebKey.fromPem(await rootBundle.loadString(_keyFileAddress));
    _securityContext.setClientAuthoritiesBytes(utf8.encode(await rootBundle.loadString(_rootsFileAddress)));
  }

  void _onData(List<MqttReceivedMessage<MqttMessage>> rawData) {
    for (var message in rawData) {
      final data = message.payload.toString();
      _printWithFrame('Data: $data');
    }
  }

  Future<void> receiveChannelValues() async {
    await _init;
    final String password = _createJWTforGoogleIot(_mqttConf, _key);
    await _client.connect(_mqttConf.username, password);
    _client.subscribe(_mqttConf.testTopic, _mqttConf.qosLevel);
    _client.updates.listen(_onData, onError: _mqttCallbacks.onError, onDone: _mqttCallbacks.onDone);
    await MqttUtilities.asyncSleep(1);
    _client.disconnect();
  }

  Future<void> sendChannelValues(Map<Channel, double> channelValues) async {
    await _init;
    final String password = _createJWTforGoogleIot(_mqttConf, _key);
    await _client.connect(_mqttConf.username, password);
    final MqttClientPayloadBuilder payloadBuilder = MqttClientPayloadBuilder();
    for (Channel channel in Channel.values) {
      payloadBuilder.addDouble(channelValues[channel]);
    }
    _client.publishMessage(_mqttConf.eventTopic, _mqttConf.qosLevel, payloadBuilder.payload, retain: true);
    await MqttUtilities.asyncSleep(5);
    _client.disconnect();
  }
}

enum _DataType { airFlow, temperature }

const Map<_DataType, String> _subfolders = {
  _DataType.airFlow: 'AirFlow',
  _DataType.temperature: 'Temperature',
};

class _GoogleMqttConfiguration {
  final String projectID;
  final String location;
  final String registryID;
  final String deviceID;
  final String clientID;

  final String topicID;

  final String eventTopic;
  final String commandTopic;

  final String airFlowTopic;
  final String temperatureTopic;
  final String testTopic;

  final String url;
  final String username;
  final int port; // 8883 or 443
  final MqttQos qosLevel;
  final bool logsAreNeeded;

  _GoogleMqttConfiguration(
      {this.projectID = 'snappy-provider-295713',
      this.deviceID = 'MyExampleDevice',
      this.location = 'asia-east1',
      this.registryID = 'MyStorage',
      this.username = 'unused',
      this.url = 'mqtt.googleapis.com',
      this.port = 8883,
      this.qosLevel = MqttQos.atMostOnce,
      this.logsAreNeeded = false,
      this.topicID = 'MyTopics'})
      : eventTopic = '/devices/$deviceID/events',
        commandTopic = '/devices/$deviceID/commands/#',
        clientID = 'projects/$projectID/locations/$location/registries/$registryID/devices/$deviceID',
        airFlowTopic = '/devices/$deviceID/events/${_subfolders[_DataType.airFlow]}',
        temperatureTopic = '/devices/$deviceID/events/${_subfolders[_DataType.temperature]}',
        testTopic = '/devices/$deviceID/commands/#';
}

class _MqttCallBacks {
  MqttServerClient addCallbacks(MqttServerClient client) {
    bool _onBadCertificate(_) {
      _printWithFrame('BAD CERTIFICATE');
      return true;
    }

    void _onUnsubscribed(String text) => _printWithFrame('UNSUBSCRIBED:  $text');
    void _onSubscribeFail(String text) => _printWithFrame('SUBSCRIBING FAILED:  $text');
    void _onConnected() => _printWithFrame('CONNECTED');
    void _onDisconnected() => _printWithFrame('DISCONNECTED');
    void _onAutoReconnect() => _printWithFrame('AUTORECONNECT');
    void _onSubscribed(String text) => _printWithFrame('SUBSCRIBED: $text');

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
}

void _printWithFrame(String text) {
  String equals = '============';
  print('$equals $text $equals');
}

String _createJWTforGoogleIot(_GoogleMqttConfiguration _mqttConf, JsonWebKey key) {
  final int secondsPerDay = 86400; //max exp.  https://cloud.google.com/iot/docs/how-tos/credentials/jwts
  final int millisecondsPerSecond = 1000;

  JsonWebTokenClaims claims = JsonWebTokenClaims.fromJson(
    {
      "aud": _mqttConf.projectID,
      "iat": (DateTime.now().millisecondsSinceEpoch) ~/ millisecondsPerSecond, //unix time
      "exp": ((DateTime.now().millisecondsSinceEpoch) ~/ millisecondsPerSecond) + secondsPerDay,
    },
  );
  JsonWebSignatureBuilder builder = JsonWebSignatureBuilder();
  builder.jsonContent = claims.toJson();
  builder.addRecipient(key, algorithm: 'RS256');
  String jwt = builder.build().toCompactSerialization();
  return jwt;
}
