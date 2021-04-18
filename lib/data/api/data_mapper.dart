import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:typed_data/typed_data.dart';

String byteData2String(ByteData data) {
  final ByteBuffer buffer = data.buffer;
  final Uint8List list = buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  return utf8.decode(list);
}

ByteData mqttMessage2ByteData(MqttReceivedMessage<MqttMessage> msg) {
  //took from  mqtt_client-9.1.0\example\mqtt_client_wildcard_filtered.dart
  MqttPublishMessage receivedMsg = msg.payload as MqttPublishMessage;
  ByteData payloadAsBytes = receivedMsg.payload.message!.buffer.asByteData();
  return payloadAsBytes;
}

Uint8Buffer string2Uint8Buffer(String str) {
  MqttClientPayloadBuilder payloadBuilder = MqttClientPayloadBuilder()..addString(str);
  return payloadBuilder.payload!;
}
