import 'package:hvac_remote_client/application/dialog/content/notice.dart';
import 'package:hvac_remote_client/application/exception/exception_handler.dart';
import 'package:hvac_remote_client/application/injection.dart';
import 'package:hvac_remote_client/domain/service/auth.dart';
import 'package:hvac_remote_client/presentation/dialog/notice_dialog.dart';

import 'view_model.dart';

enum AccountCreateStates {
  none,
  creating,
}

class AccountCreateUseCase {
  AccountCreateUseCase(this._viewModel);

  final AccountCreateViewModel _viewModel;

  final AuthService _auth = getIt.get<AuthService>();

  Future<void> createAccount(String email, String password, String repeated) async {
    try {
      _viewModel.state = AccountCreateStates.creating;
      await _auth.createAccount(email, password, repeated);
      showNoticeDialog(const SuccessfulAccountCreateNotice());
    } catch (e, s) {
      ExceptionHandler.handle(e, s);
    } finally {
      _viewModel.state = AccountCreateStates.none;
    }
  }
}
