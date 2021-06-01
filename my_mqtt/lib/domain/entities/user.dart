import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_mqtt/data/auth_service.dart';
import 'package:my_mqtt/data/repositories/user_repository.dart';
import 'package:my_mqtt/application/service_locator.dart';

class User {
  late final Roles role;

  User.fromJson(json) {
    this.role = Roles.reader;
  }

  User.newUser();
}

enum Roles {
  reader,
  adjuster,
  manufacter,
}
