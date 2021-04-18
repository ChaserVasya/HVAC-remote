import 'dart:async';

import 'package:jose/jose.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:my_mqtt/data/api/mqtt/google_mqtt_configuration.dart';
import 'package:my_mqtt/data/api/mqtt/mqtt_response_buffer.dart';
import 'package:my_mqtt/data/enums.dart';
import 'package:typed_data/typed_data.dart';

class MqttApi {
  static final MqttResponseBuffer _inputBuf = MqttResponseBuffer();
  static List<MqttMessageData> get data => _inputBuf.getDataAndCleanBuffer();

  static final GoogleMqttConfiguration _conf = GoogleMqttConfiguration();

  MqttApi._();
  

  static void _onData(List<MqttReceivedMessage<MqttMessage>> rawData) {
    _inputBuf.addMsg(rawData);
  }

  static Future<List<MqttMessageData>> receive(Endpoints endpoint) async {
    await _conf.initState;
    final String password = _createJWTforGoogleIot();
    MqttServerClient _client = _conf.client;
    await _client.connect(_conf.username, password);
    _client.subscribe(
      _conf.upperPathForReceive + endpoint.toString().split('.').last,
      _conf.qosLevel,
    );
    _client.updates!.listen(_onData, onError: _conf.mqttCallbacks.onError, onDone: _conf.mqttCallbacks.onDone);
    await MqttUtilities.asyncSleep(4);
    _client.disconnect();
    return _inputBuf.getDataAndCleanBuffer();
  }

  static Future<void> send(Uint8Buffer payload, Endpoints endpoint) async {
    await _conf.initState;
    final String password = _createJWTforGoogleIot();
    MqttServerClient _client = _conf.client;
    await _client.connect(_conf.username, password);
    _client.publishMessage(
      _conf.upperPathForSend + endpoint.toString().split('.').last,
      _conf.qosLevel,
      payload,
      retain: true,
    );
    _client.disconnect();
  }

  static Future<void> setDataflow(Endpoints endpoint) async {
    await _conf.initState;
    final String password = _createJWTforGoogleIot();
    MqttServerClient _client = _conf.client;
    await _client.connect(_conf.username, password);
    _client.subscribe(
      _conf.upperPathForReceive + endpoint.toString().split('.').last,
      _conf.qosLevel,
    );
    _client.updates!.listen(_onDataflowData, onError: _conf.mqttCallbacks.onError, onDone: _conf.mqttCallbacks.onDone);
  }

  static void _onDataflowData(List<MqttReceivedMessage<MqttMessage>> rawData) {
    _inputBuf.addMsg(rawData);
  }

  static void disposeDataflow() async {
    MqttServerClient _client = _conf.client;
    _client.disconnect();
  }

  static String _createJWTforGoogleIot() {
    const int secondsPerDay = 86400; //max exp.  https://cloud.google.com/iot/docs/how-tos/credentials/jwts
    const int millisecondsPerSecond = 1000;

    JsonWebTokenClaims claims = JsonWebTokenClaims.fromJson(
      {
        "aud": _conf.projectID,
        "iat": (DateTime.now().millisecondsSinceEpoch) ~/ millisecondsPerSecond, //unix time
        "exp": ((DateTime.now().millisecondsSinceEpoch) ~/ millisecondsPerSecond) + secondsPerDay,
      },
    );
    JsonWebSignatureBuilder builder = JsonWebSignatureBuilder();
    builder.jsonContent = claims.toJson();
    builder.addRecipient(_conf.key, algorithm: 'RS256');
    String jwt = builder.build().toCompactSerialization();
    return jwt;
  }
}
