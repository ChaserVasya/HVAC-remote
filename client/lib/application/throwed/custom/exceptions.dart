import 'custom_exception.dart';

class EmailNotVerifiedException extends CustomException {
  const EmailNotVerifiedException()
      : super(
          message: 'User`s E-mail is not verified.',
        );
}

class IncorrectRepeatedException extends CustomException {
  const IncorrectRepeatedException()
      : super(
          message: 'Repeate password mismatch with original password.',
        );
}

class RoleClaimNotExistException extends CustomException {
  const RoleClaimNotExistException()
      : super(
          message:
              'Role claim does not exist in received JWTs token. It can be a backend bug, which means that Firebase Functions delete or not set custom claims. Or they have not yet been set because of Functions async',
        );
}

//duplicates firebase unknown exception code, but for my own purposes
class EmptyStringException extends CustomException {
  const EmptyStringException()
      : super(
          message: 'Empty string not allowed.',
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
