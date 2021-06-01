import 'dart:async';

import 'package:flutter/material.dart';
import 'package:my_mqtt/application/application.dart';
import 'package:my_mqtt/application/async_exception_handler.dart';

void runZonedGuardedApp() {
  final navigatorKey = GlobalKey<NavigatorState>();
  final asyncExceptionHandler = AsyncExceptionHandler(navigatorKey);

  runZonedGuarded(
    () {
      //! must be before other things AND in [runZonedGuarded]
      WidgetsFlutterBinding.ensureInitialized();
      runApp(Application(navigatorKey));
    },
    asyncExceptionHandler.handle,
  );
}
