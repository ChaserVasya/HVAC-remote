import 'package:firebase_auth/firebase_auth.dart';

import 'common/alerts.dart';
import 'common/exception_alert.dart';
import 'custom/custom_exception.dart';
import 'custom/switch_alert.dart';
import 'firebase/switch_alert.dart';

ExceptionAlert switchExceptionAlert(Object e, StackTrace s) {
  // ignore: dead_code
  if (false) {
    // for align
  } else if (e is FirebaseException) {
    return switchFirebaseExceptionAlert(e);
  } else if (e is CustomException) {
    return switchCustomExceptionAlert(e);
  }

  return const DevErrorAlert();
}
