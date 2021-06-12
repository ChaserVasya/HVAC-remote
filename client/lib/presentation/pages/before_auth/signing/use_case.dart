import 'package:flutter/widgets.dart';
import 'package:hvac_remote_client/application/throwed/exception_handler.dart';

import 'package:hvac_remote_client/application/routes.dart';
import 'package:hvac_remote_client/domain/services/auth.dart';

import 'view_model.dart';

enum SigningStates {
  none,
  sending,
  signed,
}

class SigningUseCase {
  SigningUseCase(this._viewModel);

  final SigningViewModel _viewModel;

  final AuthService _auth = AuthService();

  void signIn(String email, String password, BuildContext context) async {
    try {
      _viewModel.state = SigningStates.sending;
      await _auth.signIn(email, password);
      _viewModel.state = SigningStates.signed;
      Navigator.pushReplacementNamed(context, RoutesNames.home);
    } catch (e, s) {
      ExceptionHandler.handle(e, s, context);
    } finally {
      _viewModel.state = SigningStates.none;
    }
  }
}
