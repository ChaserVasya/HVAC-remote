import 'dart:async';

import 'package:flutter/material.dart';
import 'package:my_mqtt/application/application.dart';
import 'package:my_mqtt/application/exception_domain/zoned_exception_handler.dart';

void main() {
  _runZonedGuardedApp();
}

void _runZonedGuardedApp() {
  final navigatorKey = GlobalKey<NavigatorState>();
  final zonedExceptionHandler = ZonedExceptionHandler(navigatorKey);

  runZonedGuarded(
    () {
      //! must be BEFORE other init and AFTER [runZonedGuarded]
      WidgetsFlutterBinding.ensureInitialized();

      _setRunAppPresets();

      //! rest initialiations are in [InitPage]
      runApp(Application(navigatorKey));
    },
    zonedExceptionHandler.handle,
  );
}

void _setRunAppPresets() {
  //TODO define flutter error handler (e.g. log or send errors)
  //FlutterError.onError = (details) => print('flutter error');
}
