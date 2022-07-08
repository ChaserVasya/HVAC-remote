import 'package:flutter/material.dart';
import 'package:hvac_remote_client/application/dialog/content/notice.dart';
import 'package:hvac_remote_client/application/exception/exception_handler.dart';
import 'package:hvac_remote_client/application/injection.dart';
import 'package:hvac_remote_client/domain/repo/role.dart';
import 'package:hvac_remote_client/presentation/dialog/notice_dialog.dart';

import 'view_model.dart';

enum ChangeRoleStates {
  none,
  changing,
}

class ChangeRoleUseCase {
  ChangeRoleUseCase(this._viewModel);

  final ChangeRoleViewModel _viewModel;
  final RoleRepo _roleRepo = getIt.get<RoleRepo>();

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
