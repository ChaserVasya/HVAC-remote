import 'package:flutter/material.dart';
import 'package:my_mqtt/data/api/mqtt/mqtt_api.dart';

import 'package:my_mqtt/data/pid_page_data.dart';
import 'package:my_mqtt/domain/pid_validator.dart';

class PidPageState with ChangeNotifier {
  PidPageState() {
    controllers = Map.fromIterable(
      Channel.values,
      key: (channel) => channel, //didnt find how to do "key: channel"
      value: (_) => TextEditingController(),
    );
    _validator = PidValidator();
    validatorFunction = (text) => _validator.validate(text);
    _checkInputsAreValid();
    //buttonAction = _changeChannelValues;
    buttonAction = _testFunction;
  }

  _TestCommandState testCommandState = _TestCommandState();

  PidValidator _validator;
  PidPageData _pidPageData = PidPageData.testData();

  void Function() buttonAction;
  String Function(String) validatorFunction;
  bool allInputsAreValid;
  Map<Channel, TextEditingController> controllers;

  get channels => _pidPageData.channels;

  void _changeChannelValues() async {
    _checkInputsAreValid();
    if (allInputsAreValid) {
      Map<Channel, double> newChannelValues = {};
      for (Channel channel in Channel.values) {
        newChannelValues.addAll({channel: double.tryParse(controllers[channel].text)});
        newChannelValues[channel] ??= _pidPageData.channels[channel];
      }
      _pidPageData.channels = newChannelValues;
      await _pidPageData.sendChannelValues(newChannelValues).whenComplete(
        () {
          print('==========SENT===========');
          /*  print('===============SEND => RECEIVE ==================');
          _pidPageData.receiveChannelValues().whenComplete(
                () => notifyListeners(),
              );
        */
        },
      );
    }
  }

  void _testFunction() {
    _pidPageData.receiveChannelValues();
  }

  void _checkInputsAreValid() {
    List<String> errorMessagesAfterValidate = [];
    for (Channel channel in Channel.values) {
      errorMessagesAfterValidate.add(_validator.validate(controllers[channel].text));
    }
    allInputsAreValid = errorMessagesAfterValidate.every((errMsg) => (errMsg == null));
    notifyListeners();
  }
}

class _TestCommandState {
  MqttApi api = MqttApi();
  bool commandIsReceived = false;
  String receivedCommand;
  void receiveCommand() {}
}
