import 'package:flutter/material.dart';
import 'package:my_mqtt/data/model/password_page_data.dart';

class PasswordPageState with ChangeNotifier {
  PasswordPageData _passwordPageData = PasswordPageData();
  bool _passwordIsCorrect = false;
  bool needToDisplayTextAboutWrongPassword = false;
  bool needToEnterToApp = false;

  void checkPassword(String text) {
    _passwordIsCorrect = (text.contains(RegExp(_passwordPageData.keyword, caseSensitive: false)));
    needToDisplayTextAboutWrongPassword = !_passwordIsCorrect;
    needToEnterToApp = _passwordIsCorrect;
    notifyListeners();
  }
}
