import 'dart:io';

import 'package:flutter/material.dart';
import 'package:my_mqtt/data/api/api.dart';
import 'package:my_mqtt/data/enums.dart';
import 'package:my_mqtt/domain/domain_component.dart';
import 'package:my_mqtt/domain/domain_mediator.dart';
import 'package:my_mqtt/internal/exceptions.dart';
import 'package:my_mqtt/presentation/snackbars.dart';

class DataflowComponent extends DomainComponent {
  static late final DataflowComponent _dataflowComponent;
  static bool _isInitialized = false;
  bool get isInitialized => _isInitialized;
  DataflowComponent._(DomainMediator domainMediator) : super(domainMediator);
  factory DataflowComponent(DomainMediator domainMediator) {
    if (_isInitialized == false) {
      _dataflowComponent = DataflowComponent._(domainMediator);
      _isInitialized = true;
    }
    return _dataflowComponent;
  }

  String _inputData = '';
  String get inputData => _inputData;
  set inputData(String inputData) {
    _inputData = inputData;
    notifyListeners();
  }

  DataflowStatuses _dataflowStatus = DataflowStatuses.notSetted;
  DataflowStatuses get dataflowStatus => _dataflowStatus;
  set dataflowStatus(DataflowStatuses dataflowStatus) {
    _dataflowStatus = dataflowStatus;
    notifyListeners();
  }

  Future<void> startDataflow(BuildContext context) async {
    _exceptionWrapper(context, _startDataflow);
  }

  void stopDataflow() {
    dataflowStatus = DataflowStatuses.disposing;
  }

  Future<void> _startDataflow() async {
    dataflowStatus = DataflowStatuses.setting;

    bool dataflowIsSetted = await Api.setDataflow();
    if (dataflowIsSetted) {
      dataflowStatus = DataflowStatuses.streaming;
    } else {
      dataflowStatus = DataflowStatuses.notSetted;
    }

    do {
      _streamingDataFromDataflow();
    } while (dataflowStatus == DataflowStatuses.streaming);

    Api.disposeDataflow();
  }

  Future<void> _streamingDataFromDataflow() async {
    await Future.delayed(Duration(seconds: 3));
    inputData = Api.takeDataFromDataflow();
  }

  Future<void> _exceptionWrapper(BuildContext context, Future<void> Function() fnc) async {
    try {
      await fnc();
    } on SocketException {
      notifyAboutBadConnection();
      ScaffoldMessenger.of(context).showSnackBar(SocketExceptionSnackbar());
    } on NullThrownError {
      ScaffoldMessenger.of(context).showSnackBar(NullExceptionSnackbar());
    } on SubscribeFailException {
      dataflowStatus = DataflowStatuses.notSetted;
    }
  }
}
