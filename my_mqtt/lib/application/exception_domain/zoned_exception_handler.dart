import 'package:flutter/material.dart';
import 'package:my_mqtt/application/exception_domain/exception_dialog.dart';
import 'package:my_mqtt/application/exception_domain/switch_alert.dart';

class ZonedExceptionHandler {
  const ZonedExceptionHandler(this.navigatorKey);

  final GlobalKey<NavigatorState> navigatorKey;

  void handle(Object e, StackTrace s) {
    print('zonedExceptionHandler catch: ' + e.toString());

    final alert = switchExceptionAlert(e);
    showExceptionDialog(alert, navigatorKey);
  }
}
