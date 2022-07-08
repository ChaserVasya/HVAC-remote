import 'package:hvac_remote_client/application/dialog/content/notice.dart';
import 'package:hvac_remote_client/application/injection.dart';
import 'package:hvac_remote_client/application/navigator.dart';
import 'package:hvac_remote_client/domain/service/auth.dart';
import 'package:hvac_remote_client/presentation/dialog/notice_dialog.dart';
import 'package:hvac_remote_client/application/exception/exception_handler.dart';

import 'package:hvac_remote_client/application/routes.dart';

import 'view_model.dart';

enum SigningStates {
  none,
  sending,
  signed,
}

class SigningUseCase {
  SigningUseCase(this._viewModel);

  final SigningViewModel _viewModel;

  final AuthService _auth = getIt.get<AuthService>();

  void signIn(String email, String password) async {
    try {
      _viewModel.state = SigningStates.sending;
      final ok = await _auth.signIn(email, password);
      if (ok) {
        _viewModel.state = SigningStates.signed;
        navigator.pushReplacementNamed(RoutesNames.home);
      } else {
        final confirmed = await showNoticeDialog(const SendEmailAgainNotice());
        if (confirmed) await _auth.sendEmailVerification();
      }
    } catch (e, s) {
      ExceptionHandler.handle(e, s);
    } finally {
      _viewModel.state = SigningStates.none;
    }
  }
}
