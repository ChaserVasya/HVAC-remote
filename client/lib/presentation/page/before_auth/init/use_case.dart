import 'package:flutter/widgets.dart';
import 'package:hvac_remote_client/application/exception/exception_handler.dart';
import 'package:hvac_remote_client/application/navigator.dart';
import 'package:hvac_remote_client/application/routes.dart';
import 'package:hvac_remote_client/application/injection.dart';

class InitUseCase {
  InitUseCase() {
    try {
      inject();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        navigator.pushReplacementNamed(RoutesNames.enter);
      });
    } catch (e, s) {
      ExceptionHandler.handle(e, s);
    }
  }
}
