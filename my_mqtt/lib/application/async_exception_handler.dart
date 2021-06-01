import 'package:flutter/material.dart';

class AsyncExceptionHandler {
  AsyncExceptionHandler(this.navigatorKey);

  final GlobalKey<NavigatorState> navigatorKey;

  void handle(Object object, _) {
    print(object);
    _showExceptionDialog(object);
  }

  void _showExceptionDialog(Object exception) {
    showDialog(
      context: navigatorKey.currentContext!,
      builder: (context) => ExceptionAlertDialog(context),
    );
  }
}
