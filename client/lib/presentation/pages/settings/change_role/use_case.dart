import 'package:flutter/material.dart';
import 'package:hvac_remote_client/application/dialogs/content/notice.dart';
import 'package:hvac_remote_client/application/exception/exception_handler.dart';
import 'package:hvac_remote_client/presentation/dialogs/notice_dialog.dart';
import 'package:hvac_remote_client/domain/repos/role.dart';

import 'view_model.dart';

enum ChangeRoleStates {
  none,
  changing,
}

class ChangeRoleUseCase {
  ChangeRoleUseCase(this._viewModel);

  final ChangeRoleViewModel _viewModel;
  final RoleRepository _roleRepo = RoleRepository();

  void changeRole(String password, BuildContext context) async {
    try {
      _viewModel.state = ChangeRoleStates.changing;
      await _roleRepo.changeRole(password);

      showNoticeDialog(const NewRoleNotice());
    } catch (e, s) {
      ExceptionHandler.handle(e, s);
    } finally {
      _viewModel.state = ChangeRoleStates.none;
    }
  }
}
