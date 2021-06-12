import 'custom_exception.dart';

class EmailNotVerifiedException extends CustomException {
  const EmailNotVerifiedException()
      : super(
          message: 'User`s E-mail is not verified.',
        );
}

class IncorrectrepeatedException extends CustomException {
  const IncorrectrepeatedException()
      : super(
          message: 'Repeate password mismatch with original password.',
        );
}

class InvalidArgumentException extends CustomException {
  const InvalidArgumentException()
      : super(
          message: 'Have been passed invalid argument.',
        );
}

class RoleClaimNotExistException extends CustomException {
  const RoleClaimNotExistException()
      : super(
          message:
              'Role claim does not exist in received JWTs token. It can be a backend bug, which means that Firebase Functions delete or not set custom claims. Or they have not yet been set because of Functions async',
        );
}

class EmptyPasswordException extends CustomException {
  const EmptyPasswordException()
      : super(
          message: 'Empty password not allowed.',
        );
}

class UnknownRoleInClaimException extends CustomException {
  const UnknownRoleInClaimException()
      : super(
          message: 'User`s JWTs claims contain unknown role.',
        );
}

class RoleNotChangedException extends CustomException {
  const RoleNotChangedException()
      : super(
          message: 'User`s JWTs claims contain unknown role.',
        );
}
