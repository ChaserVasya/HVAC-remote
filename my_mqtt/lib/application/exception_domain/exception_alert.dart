import 'package:firebase_core/firebase_core.dart';
import 'package:my_mqtt/application/exception_domain/common_alerts.dart';
import 'package:my_mqtt/application/exception_domain/custom/alerts.dart';
import 'package:my_mqtt/application/exception_domain/custom/custom_exception.dart';
import 'package:my_mqtt/application/exception_domain/firebase/alerts.dart';

abstract class ExceptionAlert {
  const ExceptionAlert({
    required this.titleForUser,
    required this.textForUser,
    this.details,
  });

  final String titleForUser;
  final String textForUser;
  final String? details;
}

ExceptionAlert switchExceptionAlert(Exception e) {
  if (e is Exception) {
    if (e is FirebaseException) {
      return switchFirebaseExceptionAlert(e);
    } else if (e is CustomException) {
      return switchCustomExceptionAlert(e);
    } else {
      return UnhandledAlert(e.toString());
    }
  } else {
    return const UnhandledAlert();
  }
}
