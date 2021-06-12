import 'package:flutter/material.dart';

import 'use_case.dart';

class AccountCreateViewModel extends ChangeNotifier {
  AccountCreateViewModel() {
    _useCase = AccountCreateUseCase(this);
  }

  late final AccountCreateUseCase _useCase;

  void createAccount(String email, String password, String repeated, BuildContext context) {
    _useCase.createAccount(email, password, repeated, context);
  }

  AccountCreateStates _state = AccountCreateStates.none;
  AccountCreateStates get state => _state;
  set state(AccountCreateStates process) {
    _state = process;
    notifyListeners();
  }
}
