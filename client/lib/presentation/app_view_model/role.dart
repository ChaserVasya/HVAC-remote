import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:hvac_remote_client/application/service_locator.dart';
import 'package:hvac_remote_client/domain/entities/role.dart';
import 'package:hvac_remote_client/domain/repos/role.dart';

class RoleViewModel extends ChangeNotifier {
  RoleViewModel() {
    final roleRepo = sl<RoleRepository>();
    role = roleRepo.lastRole;
    roleRepo.roleStream.listen((newRole) => role = newRole);
  }

  //roleStream provides values only on page build. Not from app start. wtf???
  //I init role at app start manually. after some time after building it will be refreshed.
  late Role _role;
  Role get role => _role;
  set role(Role role) {
    _role = role;
    notifyListeners();
  }
}
