import 'package:flutter/material.dart';
import 'package:my_mqtt/presentation/pages/before_auth/init/use_case.dart';

class InitViewModel extends ChangeNotifier {
  InitViewModel() {
    _useCase = InitUseCase(this);
  }

  late InitUseCase _useCase;

  Future<void>? _initializing;
  Future<void>? get initializing => _initializing;
  set initializing(Future<void>? process) {
    _initializing = process;
    notifyListeners();
  }

  void initialize(BuildContext context) => _useCase.initialize(context);
}
