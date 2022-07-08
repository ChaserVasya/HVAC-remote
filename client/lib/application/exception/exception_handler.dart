import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:hvac_remote_client/application/dialog/content/alert/common.dart';
import 'package:hvac_remote_client/application/dialog/logic/alert/main_switch.dart';

import '../../presentation/dialog/exception_dialog.dart';

class ExceptionHandler {
  ExceptionHandler._();

  static void handle(Object e, StackTrace s) {
    final alert = switchExceptionAlert(e, s);

    if ((alert is DevErrorAlert) || (alert is UnhandledAlert)) {
      FirebaseCrashlytics.instance.recordError(e, s, printDetails: true);
    }

    showExceptionDialog(alert);
  }
}
