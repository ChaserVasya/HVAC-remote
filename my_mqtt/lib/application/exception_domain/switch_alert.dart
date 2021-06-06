import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_mqtt/application/exception_domain/common/alerts.dart';
import 'package:my_mqtt/application/exception_domain/custom/custom_exception.dart';
import 'package:my_mqtt/application/exception_domain/custom/switch_alert.dart';
import 'package:my_mqtt/application/exception_domain/common/exception_alert.dart';
import 'package:my_mqtt/application/exception_domain/firebase/switch_alert.dart';

ExceptionAlert switchExceptionAlert(Object e) {
  if (e is Exception) {
    if (e is FirebaseException) {
      return switchFirebaseExceptionAlert(e);
    } else if (e is CustomException) {
      return switchCustomExceptionAlert(e);
    } else {
      return UnhandledAlert(e.toString());
    }
  } else if (e is Type) {
    //TODO handle case e is Type(thrown by statements like 'throw Exception' without '()'.). programmist's error.
    print('Exception: e is [Type] (not [Exception])');
    return const ProgrammaticalErrorAlert();
  } else {
    return const ProgrammaticalErrorAlert();
  }
}
