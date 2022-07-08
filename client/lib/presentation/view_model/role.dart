import 'package:flutter/widgets.dart';
import 'package:hvac_remote_client/application/injection.dart';
import 'package:hvac_remote_client/domain/entity/role.dart';
import 'package:hvac_remote_client/domain/repo/role.dart';

class RoleViewModel extends ChangeNotifier {
  RoleViewModel() {
    _roleRepo.streamRole().listen((newRole) => role = newRole);
  }

  final _roleRepo = getIt<RoleRepo>();

  //roleStream provides values only on page build. Not from app start. wtf???
  //I init role at app start manually. After some time after building it will be refreshed.
  late Role _role = const Role(Roles.undefined);
  Role get role => _role;
  set role(Role role) {
    _role = role;
    notifyListeners();
  }
}
