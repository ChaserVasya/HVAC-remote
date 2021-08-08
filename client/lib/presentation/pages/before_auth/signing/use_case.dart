import 'package:flutter/widgets.dart';
import 'package:hvac_remote_client/application/dialogs/content/notice.dart';
import 'package:hvac_remote_client/presentation/dialogs/notice_dialog.dart';
import 'package:hvac_remote_client/application/exception/exception_handler.dart';

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
      final ok = await _auth.signIn(email, password);
      if (ok) {
        _viewModel.state = SigningStates.signed;
        Navigator.pushReplacementNamed(context, RoutesNames.home);
      } else {
        final confirmed = await showNoticeDialog(context, const SendEmailAgainNotice());
        if (confirmed) await _auth.sendEmailVerification();
      }
    } catch (e, s) {
      ExceptionHandler.handle(e, s, context);
    } finally {
      _viewModel.state = SigningStates.none;
    }
  }
}
