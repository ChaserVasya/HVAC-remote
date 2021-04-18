import 'dart:io';

import 'package:flutter/material.dart';
import 'package:my_mqtt/data/api/api.dart';
import 'package:my_mqtt/data/enums.dart';

import 'package:my_mqtt/domain/domain_component.dart';
import 'package:my_mqtt/domain/domain_mediator.dart';
import 'package:my_mqtt/internal/exceptions.dart';
import 'package:my_mqtt/presentation/snackbars.dart';

class AuthComponent extends DomainComponent {
  static late final AuthComponent _authComponent;
  static bool _isInitialized = false;
  bool get isInitialized => _isInitialized;
  AuthComponent._(DomainMediator domainMediator) : super(domainMediator);
  factory AuthComponent(DomainMediator domainMediator) {
    if (_isInitialized == false) {
      _authComponent = AuthComponent._(domainMediator);
      _isInitialized = true;
    }
    return _authComponent;
  }

  AuthStatuses _authStatus = AuthStatuses.passwordNotChecked;
  AuthStatuses get authStatus => _authStatus;
  set authStatus(AuthStatuses authStatus) {
    _authStatus = authStatus;
    notifyListeners();
  }

  Future<void> checkPassword(BuildContext context, String password) async {
    _exceptionWrapper(context, _checkPassword, password);
  }

  Future<void> _checkPassword(String password) async {
    authStatus = AuthStatuses.passwordChecking;
    bool isAuthenticated = await Api.checkPassword(password);

    switch (isAuthenticated) {
      case true:
        authStatus = AuthStatuses.truePassword;
        break;
      case false:
        authStatus = AuthStatuses.wrongPassword;
        break;
    }
  }

  Future<void> _exceptionWrapper(BuildContext context, Future<void> Function(String) fnc, String str) async {
    try {
      await fnc(str);
    } on SocketException {
      notifyAboutBadConnection();
      ScaffoldMessenger.of(context).showSnackBar(SocketExceptionSnackbar());
      authStatus = AuthStatuses.passwordNotChecked;
    } on NullThrownError {
      ScaffoldMessenger.of(context).showSnackBar(NullExceptionSnackbar());
      authStatus = AuthStatuses.passwordNotChecked;
    } on AuthResultNotReceivedException {
      ScaffoldMessenger.of(context).showSnackBar(AuthResultNotReceivedExceptionSnackbar());
      authStatus = AuthStatuses.passwordNotChecked;
    }
  }
}
