import 'dart:io';

import 'package:flutter/material.dart';
import 'package:my_mqtt/data/api/api.dart';
import 'package:my_mqtt/data/enums.dart';
import 'package:my_mqtt/domain/domain_component.dart';
import 'package:my_mqtt/domain/domain_mediator.dart';
import 'package:my_mqtt/presentation/snackbars.dart';

class ServerConnectionComponent extends DomainComponent {
  static late final ServerConnectionComponent _serverConnectionComponent;
  static bool _isInitialized = false;
  bool get isInitialized => _isInitialized;
  ServerConnectionComponent._(DomainMediator domainMediator) : super(domainMediator);
  factory ServerConnectionComponent(DomainMediator domainMediator) {
    if (_isInitialized == false) {
      _serverConnectionComponent = ServerConnectionComponent._(domainMediator);
      _isInitialized = true;
    }
    return _serverConnectionComponent;
  }

  ServerConnectionStatuses _serverConnectionStatus = ServerConnectionStatuses.notChecked;
  ServerConnectionStatuses get serverConnectionStatus => _serverConnectionStatus;
  set serverConnectionStatus(ServerConnectionStatuses status) {
    _serverConnectionStatus = status;
    notifyListeners();
  }

  Future<void> checkServerConnection(BuildContext context) async {
    _exceptionWrapper(context, _checkServerConnection);
  }

  Future<void> _checkServerConnection() async {
    serverConnectionStatus = ServerConnectionStatuses.checking;

    bool isConnectedToServer = await Api.checkServerConnection();
    if (isConnectedToServer) {
      serverConnectionStatus = ServerConnectionStatuses.good;
    } else {
      serverConnectionStatus = ServerConnectionStatuses.bad;
    }
  }

  Future<void> _exceptionWrapper(BuildContext context, Future<void> Function() fnc) async {
    try {
      await fnc();
    } on SocketException {
      notifyAboutBadConnection();
      ScaffoldMessenger.of(context).showSnackBar(SocketExceptionSnackbar());
    } on NullThrownError {
      ScaffoldMessenger.of(context).showSnackBar(NullExceptionSnackbar());
    }
  }
}
