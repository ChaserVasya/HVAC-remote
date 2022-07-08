import 'package:hvac_remote_client/application/dialog/content/alert/common.dart';
import 'package:hvac_remote_client/application/dialog/content/alert/firebase.dart';
import 'package:hvac_remote_client/application/dialog/content/interfaces/alert.dart';
import 'package:hvac_remote_client/application/exception/exceptions.dart';
import 'package:hvac_remote_client/application/exception/custom_exception_interface.dart';

AlertDialogContent switchCustomExceptionAlert(CustomException e) {
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
