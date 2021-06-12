import 'package:hvac_remote_client/application/throwed/common/alerts.dart';
import 'package:hvac_remote_client/application/throwed/common/exception_alert.dart';

import 'alerts.dart';
import 'custom_exception.dart';
import 'exceptions.dart';

ExceptionAlert switchCustomExceptionAlert(CustomException e) {
  // ignore: dead_code
  if (false) {
    // for align
  } else if (e is EmailNotVerifiedException) {
    return EmailNotVerifiedAlert();
  } else if (e is IncorrectrepeatedException) {
    return const IncorrectrepeatedAlert();
  } else if (e is EmptyPasswordException) {
    return const EmptyPasswordAlert();
  } else if (e is RoleNotChangedException) {
    return const RoleNotChangedAlert();
  } else {
    return const UnhandledAlert();
  }
}
