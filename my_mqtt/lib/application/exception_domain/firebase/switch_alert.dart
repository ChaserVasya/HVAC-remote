import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_mqtt/application/exception_domain/common/alerts.dart';
import 'package:my_mqtt/application/exception_domain/common/exception_alert.dart';
import 'package:my_mqtt/application/exception_domain/firebase/alerts.dart';

/*
exception-codes have been taken from firebase_auth.dart. Not of all are needed. Unneeded exception-codes listed for the record. 
!exception-codes can out of date.
codes:
  account-exists-with-different-credential, //!unused
  custom-token-mismatch, //!unused
  email-already-in-use,
  expired-action-code,
  invalid-action-code,
  invalid-email,
  invalid-credential, //!unused
  invalid-custom-token, //!unused
  invalid-verification-code, //!unused
  invalid-verification-id, //!unused
  operation-not-allowed,
  user-disabled,
  user-not-found,
  weak-password,
  wrong-password,
*/

//TODO add: [firebase_auth/too-many-requests] We have blocked all requests from this device due to unusual activity. Try again later.
ExceptionAlert switchFirebaseExceptionAlert(FirebaseException e) {
  String? message = e.message;
  final details = (message != null) ? (e.plugin + '/' + e.code + '\n' + message) : (e.plugin + '/' + e.code);
  switch (e.code) {
    case 'email-already-in-use':
      return EmailAlreadyInUseAlert(details);
    case 'expired-action-code':
      return ExpiredActionCodeAlert(details);
    case 'invalid-action-code':
      return InvalidActionCodeAlert(details);
    case 'invalid-email':
      return InvalidEmailAlert(details);
    case 'invalid-verification-code':
      return InvalidVerificationCodeAlert(details);
    case 'operation-not-allowed':
      return OperationNotAllowedAlert(details);
    case 'user-disabled':
      return UserDisabledAlert(details);
    case 'user-not-found':
      return UserNotFoundAlert(details);
    case 'weak-password':
      return WeakPasswordAlert(details);
    case 'wrong-password':
      return WrongPasswordAlert(details);
    default:
      return UnhandledAlert(details);
  }
}
