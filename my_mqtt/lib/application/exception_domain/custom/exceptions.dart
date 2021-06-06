import 'package:my_mqtt/application/exception_domain/custom/custom_exception.dart';

class EmailNotVerifiedException extends CustomException {
  const EmailNotVerifiedException()
      : super(
          message: 'User`s E-mail is not verified.',
        );
}

class IncorrectRepeatedPasswordException extends CustomException {
  const IncorrectRepeatedPasswordException()
      : super(
          message: 'Repeate password mismatch with original password.',
        );
}
