import 'package:flutter/material.dart';
import 'package:hvac_remote_client/application/dialogs/content/notice.dart';
import 'package:hvac_remote_client/application/exception/exception_handler.dart';
import 'package:hvac_remote_client/presentation/dialogs/notice_dialog.dart';

import 'package:hvac_remote_client/domain/services/auth.dart';

import 'view_model.dart';

enum AccountCreateStates {
  none,
  creating,
}

class AccountCreateUseCase {
  AccountCreateUseCase(this._viewModel);

  final AccountCreateViewModel _viewModel;

  final AuthService _auth = AuthService();

  Future<void> createAccount(
      String email, String password, String repeated, BuildContext context) async {
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
