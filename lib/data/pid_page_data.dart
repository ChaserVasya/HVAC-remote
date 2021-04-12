import 'dart:math';

import 'package:mqtt_client/mqtt_client.dart';
import 'package:my_mqtt/data/api/mqtt/mqtt_api.dart';

enum Channel { P, I, D }

class PidPageData {
  final Map<Channel, double> _channels = {};

  MqttApi _apiChannels;

  PidPageData.testData() {
    _apiChannels = MqttApi();
    Random randomNumberGenerator = Random();

    for (Channel channel in Channel.values) {
      _channels[channel] = randomNumberGenerator.nextDouble();
    }
  }

  set channels(Map<Channel, double> newValues) {
    for (Channel channel in newValues.keys) {
      _channels[channel] = newValues[channel] ?? _channels[channel];
    }
  }

  Map<Channel, double> get channels => _channels;
  Future<void> sendChannelValues(Map<Channel, double> newChannelsValues) {
    return null;
  }

  Future<void> receiveChannelValues() {
    return null;
  }
}
