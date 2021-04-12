import 'dart:async';

import 'package:jose/jose.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:my_mqtt/data/api/api.dart';
import 'package:my_mqtt/data/api/mqtt/google_mqtt_configuration.dart';
import 'package:my_mqtt/data/api/mqtt/mqtt_response_buffer.dart';

class MqttApi {
  MqttResponseBuffer _inputBuf = MqttResponseBuffer();
  GoogleMqttConfiguration _conf = GoogleMqttConfiguration();

  static final MqttApi _mqttApi = MqttApi._();
  factory MqttApi() => _mqttApi;
  MqttApi._();

  void _onData(List<MqttReceivedMessage<MqttMessage>> rawData) {
    _inputBuf.add(rawData);
  }

  Future<List<MqttMessageData>> receive(Endpoint endpoint) async {
    await _conf.initState;
    final String password = _createJWTforGoogleIot(_conf);
    MqttServerClient _client = _conf.client;
    await _client.connect(_conf.username, password);
    _client.subscribe(
      _conf.upperPathForReceive + endpoint.toString().split('.').last,
      _conf.qosLevel,
    );
    _client.updates.listen(_onData, onError: _conf.mqttCallbacks.onError, onDone: _conf.mqttCallbacks.onDone);
    await MqttUtilities.asyncSleep(60);
    _client.disconnect();
    return _inputBuf.getDataAndCleanBuffer();
  }

  Future<void> send(MqttClientPayloadBuilder payloadBuilder, Endpoint endpoint) async {
    await _conf.initState;
    final String password = _createJWTforGoogleIot(_conf);
    MqttServerClient _client = _conf.client;
    await _client.connect(_conf.username, password);
    _client.publishMessage(
      _conf.upperPathForSend + endpoint.toString().split('.').last,
      _conf.qosLevel,
      payloadBuilder.payload,
      retain: true,
    );
    await MqttUtilities.asyncSleep(60);
    _client.disconnect();
  }
}

String _createJWTforGoogleIot(GoogleMqttConfiguration conf) {
  const int secondsPerDay = 86400; //max exp.  https://cloud.google.com/iot/docs/how-tos/credentials/jwts
  const int millisecondsPerSecond = 1000;

  JsonWebTokenClaims claims = JsonWebTokenClaims.fromJson(
    {
      "aud": conf.projectID,
      "iat": (DateTime.now().millisecondsSinceEpoch) ~/ millisecondsPerSecond, //unix time
      "exp": ((DateTime.now().millisecondsSinceEpoch) ~/ millisecondsPerSecond) + secondsPerDay,
    },
  );
  JsonWebSignatureBuilder builder = JsonWebSignatureBuilder();
  builder.jsonContent = claims.toJson();
  builder.addRecipient(conf.key, algorithm: 'RS256');
  String jwt = builder.build().toCompactSerialization();
  return jwt;
}
