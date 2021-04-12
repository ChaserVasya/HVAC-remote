import 'package:flutter/material.dart';

import 'package:my_mqtt/data/model/user_model.dart';
import 'package:my_mqtt/data/password_page_data.dart';
import 'package:my_mqtt/internal/application.dart';

class PasswordPageDomain extends ChangeNotifier {
  final UserModel _user = UserModel();
  final PasswordPageData _passwordPageData = PasswordPageData();
  final TextEditingController passwordController = TextEditingController();
  PasswordPageState passwordPageState = PasswordPageState.notEnteredPasswordState;

  void enterToApp(BuildContext context) {
    _user.checkPassword(passwordController.text);
    if (_user.isAuthenticated) {
      Navigator.pushNamed(context, pagesNames[Pages.PidPage]);
    } else {
      passwordPageState = PasswordPageState.wrongPasswordState;
      notifyListeners();
    }
  }
}

enum PasswordPageState {
  wrongPasswordState,
  notEnteredPasswordState,
}
