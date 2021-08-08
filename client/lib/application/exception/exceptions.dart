import 'custom_exception_interface.dart';

class EmailNotVerifiedException implements CustomException {
  @override
  final String message = 'User`s E-mail is not verified.';
}

class IncorrectRepeatedException implements CustomException {
  @override
  final String message = 'Repeate password mismatch with original password.';
}

class RoleClaimNotExistException implements CustomException {
  @override
  final String message =
      'Role claim does not exist in received JWTs token. It can be a backend bug, which means that Firebase Functions delete or not set custom claims. Or they have not yet been set because of Functions async';
}

class EmptyStringException implements CustomException {
  @override
  final String message = 'Empty string not allowed.';
}

class UnknownRoleInClaimException implements CustomException {
  @override
  final String message = 'User`s JWTs claims contain unknown role.';
}

class RoleNotChangedException implements CustomException {
  @override
  final String message = 'User`s JWTs claims contain unknown role.';
}
