import 'package:firebase_auth/firebase_auth.dart';
import 'package:hvac_remote_client/application/dialog/content/alert/common.dart';
import 'package:hvac_remote_client/application/exception/custom_exception_interface.dart';

import '../../content/interfaces/alert.dart';
import 'custom.dart';
import 'firebase.dart';

AlertDialogContent switchExceptionAlert(Object e, StackTrace s) {
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
