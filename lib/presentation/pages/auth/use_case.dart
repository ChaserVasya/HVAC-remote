import 'package:my_mqtt/data/repositories/user_repository.dart';
import 'package:my_mqtt/domain/entities/user.dart';
import 'package:my_mqtt/domain/service_locator.dart';
import 'package:my_mqtt/presentation/pages/auth/states.dart';
import 'package:my_mqtt/presentation/pages/auth/viev_model.dart';

class PasswordUseCase {
  PasswordUseCase(this._viewModel) {
    Future<void> init() async {
      _user = await locator<UserRepository>().getUser();
    }

    _init = init();
  }
  final PasswordViewModel _viewModel;
  late final User _user;

  late Future<void> _init;

  Future<void> handle(PasswordEvents event, String password) async {
    switch (event) {
      case PasswordEvents.checkPassword:
        await _init;
        _viewModel.role = _user.upRole(password);
        break;
    }
  }
}
