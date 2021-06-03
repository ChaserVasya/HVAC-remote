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
  set accountCreating(Future<void>? accountCreating) {
    _accountCreating = accountCreating;
    notifyListeners();
  }

  Future<void>? get logining => _logining;
  set logining(Future<void>? logining) {
    _logining = logining;
    notifyListeners();
  }

  Future<void>? get logouting => _logouting;
  set logouting(Future<void>? logouting) {
    _logouting = logouting;
    notifyListeners();
  }

  Future<void>? get roleChanging => _roleChanging;
  set roleChanging(Future<void>? roleChanging) {
    _roleChanging = roleChanging;
    notifyListeners();
  }

  Future<void>? get sendingVerifyingEmail => _sendingVerifyingEmail;
  set sendingVerifyingEmail(Future<void>? sendingVerifyingEmail) {
    _sendingVerifyingEmail = sendingVerifyingEmail;
    notifyListeners();
  }

  void changeRole(String password) => _useCases.changeRole(password);
  void createAccount(String email, String password) => _useCases.createAccount(email, password);
  void logIn(String email, String password) => _useCases.logIn(email, password);
  void logOut() => _useCases.logOut();
  void sendVerifyingEmail() => _useCases.sendVerifyingEmail();
}
