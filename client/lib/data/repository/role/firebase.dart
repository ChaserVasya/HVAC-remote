import 'dart:async';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hvac_remote_client/application/exception/exceptions.dart';
import 'package:hvac_remote_client/domain/entity/role.dart';
import 'package:hvac_remote_client/domain/repo/role.dart';

class FirebaseRoleRepo implements RoleRepo {
  FirebaseRoleRepo() {
    //TODO so many identical events for short time. check may i optimize it
    roleStream = _auth.idTokenChanges().asyncMap<Role>(
      (user) async {
        if (user == null) return const Role(Roles.undefined);
        final claims = (await user.getIdTokenResult(true)).claims!;
        final role = _claimsToRole(claims);
        return role;
      },
    );
    roleStream.listen((role) => lastRole = role);
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFunctions _functions = FirebaseFunctions.instance;

  late Role lastRole;
  late final Stream<Role> roleStream;

  @override
  Future<void> changeRole(String password) async {
    final bool ok = (await _functions.httpsCallable('changeRole').call(password)).data;
    if (!ok) throw RoleNotChangedException();
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

  @override
  Future<Role> getRole() async => lastRole;

  @override
  Stream<Role> streamRole() => roleStream;
}
