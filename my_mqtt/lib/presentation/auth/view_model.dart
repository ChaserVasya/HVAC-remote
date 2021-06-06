import 'package:flutter/material.dart';
import 'package:my_mqtt/presentation/auth/use_case.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthUseCases _useCases = AuthUseCases();

  Future<void>? _roleChanging;
  Future<void>? _sendingVerifyingEmail;
  Future<void>? _logouting;
  Future<void>? _logining;
  Future<void>? _accountCreating;

  Future<void>? get accountCreating => _accountCreating;
  Future<void>? get logining => _logining;
  Future<void>? get logouting => _logouting;
  Future<void>? get roleChanging => _roleChanging;
  Future<void>? get sendingVerifyingEmail => _sendingVerifyingEmail;

  void changeRole(String password) {
    _roleChanging = _useCases.changeRole(password);
    notifyListeners();
  }

  void createAccount(String email, String password, String repeatedPassword) {
    _accountCreating = _useCases.createAccount(email, password, repeatedPassword);
    notifyListeners();
  }

  void logIn(String email, String password) {
    _logining = _useCases.logIn(email, password);
    notifyListeners();
  }

  void logOut() {
    _logouting = _useCases.logOut();
    notifyListeners();
  }

  void sendVerifyingEmail() {
    _sendingVerifyingEmail = _useCases.sendVerifyingEmail();
    notifyListeners();
  }
}
