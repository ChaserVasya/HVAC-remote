import 'package:flutter/cupertino.dart';

import 'use_case.dart';

class SigningViewModel extends ChangeNotifier {
  SigningViewModel() {
    _useCase = SigningUseCase(this);
  }

  late final SigningUseCase _useCase;

  SigningStates _state = SigningStates.none;
  SigningStates get state => _state;
  set state(SigningStates state) {
    _state = state;
    notifyListeners();
  }

  void signIn(String email, String password, BuildContext context) {
    _useCase.signIn(email, password, context);
  }
}
