import 'package:flutter/cupertino.dart';

import 'use_case.dart';

class ChangeRoleViewModel extends ChangeNotifier {
  ChangeRoleViewModel() {
    _useCase = ChangeRoleUseCase(this);
  }

  late final ChangeRoleUseCase _useCase;

  ChangeRoleStates _state = ChangeRoleStates.none;
  ChangeRoleStates get state => _state;
  set state(ChangeRoleStates state) {
    _state = state;
    notifyListeners();
  }

  void changeRole(String password, BuildContext context) {
    _useCase.changeRole(password, context);
  }
}
