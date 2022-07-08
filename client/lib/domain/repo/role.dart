import 'dart:async';

import 'package:hvac_remote_client/domain/entity/role.dart';

abstract class RoleRepo {
  Future<void> changeRole(String password);
  Future<Role> getRole();
  Stream<Role> streamRole();
}
