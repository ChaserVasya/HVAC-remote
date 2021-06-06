import 'package:my_mqtt/application/exception_domain/common/alerts.dart';
import 'package:my_mqtt/application/exception_domain/custom/alerts.dart';
import 'package:my_mqtt/application/exception_domain/custom/custom_exception.dart';
import 'package:my_mqtt/application/exception_domain/custom/exceptions.dart';
import 'package:my_mqtt/application/exception_domain/common/exception_alert.dart';

ExceptionAlert switchCustomExceptionAlert(CustomException e) {
  if (e is EmailNotVerifiedException) {
    return EmailNotVerifiedAlert();
  } else if (e is IncorrectRepeatedPasswordException) {
    return const IncorrectRepeatedPasswordAlert();
  } else {
    return UnhandledAlert(e.message);
  }
}
