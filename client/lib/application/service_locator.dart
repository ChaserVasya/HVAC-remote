import 'package:get_it/get_it.dart';
import 'package:hvac_remote_client/domain/repos/role.dart';

final GetIt sl = GetIt.instance; //service locator

void setupLocator() {
  sl.registerSingleton(RoleRepository());
}
