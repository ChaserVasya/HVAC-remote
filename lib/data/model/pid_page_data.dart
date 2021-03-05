import 'dart:math';

import 'package:my_mqtt/data/model/api/api_channels.dart';

enum Channel { P, I, D }

class PidPageData {
  final Map<Channel, double> _channels = {};

  ApiChannels _apiChannels;

  PidPageData.testData() {
    _apiChannels = ApiChannels();
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
    return _apiChannels.sendChannelValues(newChannelsValues);
  }

  Future<void> receiveChannelValues() {
    return _apiChannels.receiveChannelValues();
  }
}
