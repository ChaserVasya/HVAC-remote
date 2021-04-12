import 'package:flutter/services.dart';
import 'package:mqtt_client/mqtt_client.dart';

class MqttResponseBuffer {
  List<Map<DateTime, List<MqttReceivedMessage<MqttMessage>>>> _responseBuffer = [];

  void add(List<MqttReceivedMessage<MqttMessage>> rawData) => _responseBuffer.add({DateTime.now(): rawData});

  ByteData _msg2ByteData(MqttReceivedMessage<MqttMessage> msg) {
    MqttPublishMessage receivedMsg = msg.payload;
    ByteData payloadAsBytes = receivedMsg.payload.message.buffer.asByteData();
    return payloadAsBytes;
  }

  List<MqttMessageData> getDataAndCleanBuffer() {
    List<MqttMessageData> outList = [];
    _responseBuffer.forEach(
      (dataEvent) {
        dataEvent.forEach(
          (date, msgs) {
            msgs.forEach(
              (msg) {
                outList.add(
                  MqttMessageData(
                    duplicate: msg.payload.header.duplicate,
                    date: date,
                    messageSize: msg.payload.header.messageSize,
                    messageType: msg.payload.header.messageType,
                    qos: msg.payload.header.qos,
                    retain: msg.payload.header.retain,
                    data: _msg2ByteData(msg),
                  ),
                );
              },
            );
          },
        );
      },
    );
    _responseBuffer.clear();
    return outList;
  }
}

class MqttMessageData {
  MqttMessageData({
    this.duplicate,
    this.date,
    this.messageSize,
    this.messageType,
    this.qos,
    this.retain,
    this.data,
  });

  final DateTime date;
  final bool duplicate;
  final MqttQos qos;
  final MqttMessageType messageType;
  final bool retain;
  final int messageSize;

  final ByteData data;
}
