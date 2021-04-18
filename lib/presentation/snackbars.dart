import 'package:flutter/material.dart';

class AuthResultNotReceivedExceptionSnackbar extends SnackBar {
  const AuthResultNotReceivedExceptionSnackbar()
      : super(
          content: const Text('Ответ сервера не содержит результата аутентификации'),
        );
}

class ExceptionSnackbar extends SnackBar {
  const ExceptionSnackbar() : super(content: const Text('Неизвестная ошибка'));
}

class NullExceptionSnackbar extends SnackBar {
  const NullExceptionSnackbar()
      : super(
          content: const Text('Получено недопустимое значение (Null). Причина: некорректная работа приложения или сервера'),
        );
}

class SocketExceptionSnackbar extends SnackBar {
  const SocketExceptionSnackbar() : super(content: const Text('Проверьте интернет соединение'));
}
