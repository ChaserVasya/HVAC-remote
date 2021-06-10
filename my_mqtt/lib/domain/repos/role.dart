import 'dart:async';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_mqtt/application/exception/custom/exceptions.dart';
import 'package:my_mqtt/domain/entities/role.dart';

class RoleRepository {
  RoleRepository() {
    //TODO so many identical events for short time. check may i optimize it
    roleStream = _auth.idTokenChanges().asyncMap<Role>(
      (user) async {
        if (user == null) return const Role(Roles.undefined);
        final claims = (await user.getIdTokenResult(true)).claims!;
        final role = _claimsToRole(claims);
        print('=================== ${role.localizedName}===================');
        return role;
      },
    );
    roleStream.listen((role) => lastRole = role);
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFunctions _functions = FirebaseFunctions.instance;

  late Role lastRole;
  late final Stream<Role> roleStream;

  Future<void> changeRole(String password) async {
    final bool ok = (await _functions.httpsCallable('changeRole').call(password)).data;
    if (!ok) throw const RoleNotChangedException();
    _auth.currentUser!.getIdToken(true); //to force token refreshing
  }

  Role _claimsToRole(Map<String, dynamic> claims) {
    if (!claims.containsKey('role')) return const Role(Roles.undefined);
    switch (claims['role']) {
      case 'adjuster':
        return const Role(Roles.adjuster);
      case 'reader':
        return const Role(Roles.reader);
      case 'manufacter':
        return const Role(Roles.manufacter);
      default:
        return const Role(Roles.undefined);
    }
  }
}
