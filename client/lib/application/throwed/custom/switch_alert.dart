import 'package:hvac_remote_client/application/throwed/common/alerts.dart';
import 'package:hvac_remote_client/application/throwed/common/exception_alert.dart';

import 'alerts.dart';
import 'custom_exception.dart';
import 'exceptions.dart';

ExceptionAlert switchCustomExceptionAlert(CustomException e) {
  // ignore: dead_code
  if (false) {
    // for align
  } else if (e is IncorrectRepeatedException) {
    return const IncorrectrepeatedAlert();
  } else if (e is RoleNotChangedException) {
    return const RoleNotChangedAlert();
  } else if (e is EmptyStringException) {
    return const EmptyStringAlert();
  } else {
    return const DevErrorAlert();
  }
}

//TODO decide is EmailNotVerifyed an Exception or a valid behavior (null\false) 
//TODO resort other Exceptions in the same order