import 'package:flutter/material.dart';
import 'package:my_mqtt/application/exception/exception_handler.dart';
import 'package:my_mqtt/application/notice/notice_dialog.dart';
import 'package:my_mqtt/application/notice/notices.dart';
import 'package:my_mqtt/domain/repos/role.dart';

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

      showNoticeDialog(context, NewRoleNotice());
    } catch (e, s) {
      ExceptionHandler.handle(e, s, context);
    } finally {
      _viewModel.state = ChangeRoleStates.none;
    }
  }
}
