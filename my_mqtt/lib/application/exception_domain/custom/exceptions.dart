import 'package:my_mqtt/application/exception_domain/custom/custom_exception.dart';

class EmailVerifyingException extends CustomException {
  const EmailVerifyingException()
      : super(
          message: 'User`s E-mail is not verified.',
        );
}
