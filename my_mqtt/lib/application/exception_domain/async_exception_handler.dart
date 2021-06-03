import 'package:flutter/material.dart';
import 'package:my_mqtt/application/exception_domain/dialog.dart';
import 'package:my_mqtt/application/exception_domain/exception_alert.dart';

class AsyncExceptionHandler {
  const AsyncExceptionHandler(this.navigatorKey);

  final GlobalKey<NavigatorState> navigatorKey;

  void handle(Object e, StackTrace s) {
    print(e);

    if (e is Exception) {
      final alert = switchExceptionAlert(e);
      showExceptionDialog(alert, navigatorKey);
    }
  }
}
