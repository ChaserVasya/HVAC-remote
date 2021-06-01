import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:my_mqtt/application/service_locator.dart';
import 'package:my_mqtt/data/daos/prefs_dao.dart';
import 'package:my_mqtt/domain/entities/user.dart';
import 'package:my_mqtt/domain/repository_interfaces/i_user_repository.dart';

class UserRepository implements IUserRepository {
  User? _user;
  PrefsDao _prefs = PrefsDao();

  @override
  Future<User> getUser() async {
    var user = _user;
    if (user == null) {
      user = _createUser();
      _user = user;
      saveUser();
    }
    return user;
  }

  Future<bool> saveUser() async => _prefs.setString(PrefsKeys.userJson, jsonEncode(_user));

  User _createUser() => _prefs.contains(PrefsKeys.userJson) ? _getUserFromLocal() : User.newUser();
  User _getUserFromLocal() => User.fromJson(jsonDecode(_prefs.getString(PrefsKeys.userJson)!));
}
