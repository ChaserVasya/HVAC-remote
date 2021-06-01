import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:my_mqtt/presentation/auth/use_case.dart';

class AuthViewModel extends ChangeNotifier {
  late final AuthUseCases _useCases;

  Future<HttpsCallableResult>? _roleChanging;
  Future<void>? _sendingVerifyingEmail;
  Future<void>? _logouting;
  Future<void>? _logining;

  Future<void>? _accountCreating;
  AuthViewModel() {
    _useCases = AuthUseCases();
  }
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

  Future<HttpsCallableResult>? get roleChanging => _roleChanging;
  set roleChanging(Future<HttpsCallableResult>? roleChanging) {
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
