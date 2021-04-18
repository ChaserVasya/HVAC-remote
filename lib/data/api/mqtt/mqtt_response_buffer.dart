import 'package:flutter/services.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:my_mqtt/data/api/data_mapper.dart';

class MqttResponseBuffer {
  List<Map<DateTime, List<MqttReceivedMessage<MqttMessage>>>> _responseBuffer = [];

  void addMsg(List<MqttReceivedMessage<MqttMessage>> rawData) => _responseBuffer.add({DateTime.now(): rawData});

  List<MqttMessageData> getDataAndCleanBuffer() {
    List<MqttMessageData> list = [];
    for (var dataEvent in _responseBuffer) {
      for (var msgs in dataEvent.values) {
        for (var msg in msgs) {
          list.add(
            MqttMessageData(
              duplicate: msg.payload.header!.duplicate,
              date: dataEvent.keys.single,
              messageSize: msg.payload.header!.messageSize,
              messageType: msg.payload.header!.messageType!,
              qos: msg.payload.header!.qos,
              retain: msg.payload.header!.retain,
              data: mqttMessage2ByteData(msg),
            ),
          );
        }
      }
    }

    _responseBuffer.clear();
    return list;
  }
}

class MqttMessageData {
  MqttMessageData({
    required this.duplicate,
    required this.date,
    required this.messageSize,
    required this.messageType,
    required this.qos,
    required this.retain,
    required this.data,
  });

  final DateTime date;
  final bool duplicate;
  final MqttQos qos;
  final MqttMessageType messageType;
  final bool retain;
  final int messageSize;

  final ByteData data;
}
