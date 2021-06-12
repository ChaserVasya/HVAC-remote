import 'package:flutter/material.dart';
import 'package:hvac_remote_client/application/throwed/exception_handler.dart';
import 'package:hvac_remote_client/application/notice/notice_dialog.dart';
import 'package:hvac_remote_client/application/notice/notices.dart';

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

  Future<void> createAccount(String email, String password, String repeated, BuildContext context) async {
    try {
      _viewModel.state = AccountCreateStates.creating;
      await _auth.createAccount(email, password, repeated);
      showNoticeDialog(context, const SuccessfulAccountCreateNotice());
    } catch (e, s) {
      ExceptionHandler.handle(e, s, context);
    } finally {
      _viewModel.state = AccountCreateStates.none;
    }
  }
}
