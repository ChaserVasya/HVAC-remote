import 'package:flutter/material.dart';

abstract class ExceptionSnackBar extends SnackBar {
  ExceptionSnackBar({required text})
      : super(
          content: Text(text, style: TextStyle(color: Colors.white)),
          duration: Duration(seconds: 10),
          backgroundColor: Colors.red,
        );
}

class SocketExceptionSnackbar extends ExceptionSnackBar {
  SocketExceptionSnackbar()
      : super(
          text: 'Проверьте интернет соединение',
        );
}
