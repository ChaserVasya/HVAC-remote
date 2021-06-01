import 'dart:async';

import 'package:flutter/material.dart';
import 'package:my_mqtt/domain/entities/outer_device.dart';
import 'package:my_mqtt/presentation/pages/test/states.dart';
import 'package:my_mqtt/presentation/pages/test/use_case.dart';

class TestViewModel extends ChangeNotifier {
  TestViewModel() {
    _useCase = TestUseCase(this);
  }
  late final TestUseCase _useCase;

  Future<OuterDeviceStatuses>? _checkOuterDeviceSub;
  Future<OuterDeviceStatuses>? get checkOuterDeviceSub => _checkOuterDeviceSub;
  set checkOuterDeviceSub(Future<OuterDeviceStatuses>? value) {
    _checkOuterDeviceSub = value;
    notifyListeners();
  }

  Stream<String>? _stream;
  Stream<String>? get stream => _stream;
  set stream(Stream<String>? stream) {
    _stream = stream;
    notifyListeners();
  }

  bool _switchValue = false;
  bool get switchValue => _switchValue;
  set switchValue(bool newValue) {
    _switchValue = newValue;
    notifyListeners();
  }

  void setStream() async {
    _useCase.handle(TestEvents.startStream);
  }

  void stopStream() {
    _useCase.handle(TestEvents.stopStream);
  }

  void checkOuterDeviceStatus() {
    _useCase.handle(TestEvents.checkOuterDeviceStatus);
  }
}
