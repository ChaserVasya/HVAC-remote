import 'package:flutter/widgets.dart';
import 'package:hvac_remote_client/application/throwed/exception_handler.dart';
import 'package:hvac_remote_client/application/routes.dart';
import 'package:hvac_remote_client/application/service_locator.dart';

class InitUseCase {
  InitUseCase(BuildContext context) {
    try {
      setupLocator();
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, RoutesNames.enter);
      });
    } catch (e, s) {
      ExceptionHandler.handle(e, s, context);
    }
  }
}
