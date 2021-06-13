import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';

import 'common/alerts.dart';
import 'exception_dialog.dart';
import 'switch_alert.dart';

class ExceptionHandler {
  ExceptionHandler._();

  static void handle(Object e, StackTrace s, BuildContext context) {
    final alert = switchExceptionAlert(e, s);

    if ((alert is DevErrorAlert) || (alert is UnhandledAlert)) {
      FirebaseCrashlytics.instance.recordError(e, s);
    }

    showExceptionDialog(alert, context);
  }
}
