import 'package:flutter/material.dart';

import 'exception_dialog.dart';
import 'switch_alert.dart';

class ExceptionHandler {
  ExceptionHandler._();

  static void handle(
    Object e,
    StackTrace s,
    BuildContext context,
  ) {
    print('ExceptionHandler catch: ' + e.toString());
    print(s);

    final alert = switchExceptionAlert(e);
    showExceptionDialog(alert, context);
  }
}
