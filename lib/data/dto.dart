import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:typed_data/typed_data.dart';

class Dto {
  String event2string(List<MqttReceivedMessage<MqttMessage>> msgs) {
    String accum = "";
    for (var msg in msgs) {
      String newStr = (_msg2String(msg));
      accum = accum + newStr;
    }
    return accum;
  }

  String _byteData2String(ByteData data) {
    final ByteBuffer buffer = data.buffer;
    final Uint8List list = buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    return utf8.decode(list);
  }

  ByteData _msg2ByteData(MqttReceivedMessage<MqttMessage> msg) {
    //took from  mqtt_client-9.1.0\example\mqtt_client_wildcard_filtered.dart
    MqttPublishMessage receivedMsg = msg.payload as MqttPublishMessage;
    ByteData payloadAsBytes = receivedMsg.payload.message!.buffer.asByteData();
    return payloadAsBytes;
  }

  String _msg2String(MqttReceivedMessage<MqttMessage> msg) {
    return _byteData2String(_msg2ByteData(msg));
  }

  Uint8Buffer string2payload(String str) {
    MqttClientPayloadBuilder payloadBuilder = MqttClientPayloadBuilder()..addString(str);
    return payloadBuilder.payload!;
  }

  List<String> accumulated2strings(List<Map<DateTime, List<MqttReceivedMessage<MqttMessage>>>> input) {
    List<String> list = [];
    for (var event in input) {
      for (var msgs in event.values) {
        for (var msg in msgs) {
          list.add(_msg2String(msg));
        }
      }
    }
    return list;
  }
}
