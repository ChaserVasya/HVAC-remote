import 'dart:async';

import 'package:jose/jose.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:my_mqtt/data/api/mqtt/google_mqtt_configuration.dart';
import 'package:my_mqtt/domain/enums.dart';
import 'package:typed_data/typed_data.dart';

class MqttDb {
  final GoogleMqttConfiguration _conf = GoogleMqttConfiguration();

  Future<List<Map<DateTime, List<MqttReceivedMessage<MqttMessage>>>>> receiveConfig() async {
    final _MessageAccumulator accum = _MessageAccumulator();
    await _conf.init;
    final String password = _createJWTforGoogleIot();
    MqttServerClient _client = _conf.client;
    await _client.connect(_conf.username, password);
    _client.subscribe(
      _conf.upperPathForReceive + "config",
      _conf.qosLevel,
    );
    _client.updates!.listen(
      (data) {
        accum.add(data);
      },
      onError: _conf.mqttCallbacks.onError,
      onDone: _conf.mqttCallbacks.onDone,
    );
    await MqttUtilities.asyncSleep(2);
    _client.disconnect();
    return accum.drain();
  }

  Future<void> send(Uint8Buffer payload, Endpoints endpoint) async {
    await _conf.init;
    final String password = _createJWTforGoogleIot();
    MqttServerClient _client = _conf.client;
    final String subtopic = endpoint.toString().split('.').last;
    await _client.connect(_conf.username, password);
    _client.publishMessage(_conf.upperPathForSend + subtopic, _conf.qosLevel, payload);
    _client.disconnect();
  }

  Future<Stream<List<MqttReceivedMessage<MqttMessage>>>?> getCommandStream() async {
    await _conf.init;
    final String password = _createJWTforGoogleIot();
    final String topic = _conf.upperPathForReceive + 'commands/#';
    MqttServerClient _client = _conf.client;
    await _client.connect(_conf.username, password);
    _client.subscribe(topic, _conf.qosLevel);
    return _client.updates!;
  }

  void disposeCommandStream() async {
    MqttServerClient _client = _conf.client;
    final String topic = _conf.upperPathForReceive + 'commands/#';
    _client.unsubscribe(topic);
    _client.disconnect();
  }

  String _createJWTforGoogleIot() {
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

class _MessageAccumulator {
  List<Map<DateTime, List<MqttReceivedMessage<MqttMessage>>>> _responseBuffer = [];
  void add(List<MqttReceivedMessage<MqttMessage>> rawData) => _responseBuffer.add({DateTime.now(): rawData});
  List<Map<DateTime, List<MqttReceivedMessage<MqttMessage>>>> drain() => _responseBuffer;
}
