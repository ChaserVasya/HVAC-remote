import 'package:get_it/get_it.dart';
import 'package:hvac_remote_client/data/repository/role/firebase.dart';
import 'package:hvac_remote_client/data/service/auth/firebase.dart';
import 'package:hvac_remote_client/domain/repo/role.dart';
import 'package:hvac_remote_client/domain/service/auth.dart';

final GetIt getIt = GetIt.instance;

void inject() {
  getIt.registerSingleton<RoleRepo>(
    FirebaseRoleRepo(),
  );

  getIt.registerSingleton<AuthService>(
    FirebaseAuthService(),
  );
}
