import 'package:flutter/material.dart';
import 'package:my_mqtt/domain/entities/user.dart';
import 'package:my_mqtt/presentation/pages/auth/states.dart';
import 'package:my_mqtt/presentation/pages/auth/use_case.dart';

class PasswordViewModel extends ChangeNotifier {
  factory PasswordViewModel() => _viewModel;
  PasswordViewModel._();
  static PasswordViewModel _viewModel = PasswordViewModel._();

  late final PasswordUseCase _useCase = PasswordUseCase(this);

  Future<Roles>? _role;
  Future<Roles>? get role => _role;
  set role(Future<Roles>? newState) {
    _role = newState;
    notifyListeners();
  }

  void checkPassword(BuildContext context, String password) async {
    _useCase.handle(PasswordEvents.checkPassword, password);
  }
}
