import 'package:get_it/get_it.dart';
import 'package:hvac_remote_client/data/repository/role/firebase.dart';
import 'package:hvac_remote_client/domain/repo/role.dart';

final GetIt getIt = GetIt.instance; //service locator

void inject() {
  getIt.registerSingleton<RoleRepo>(
    FirebaseRoleRepo(),
  );
}
