import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';
import 'package:my_mqtt/domain/repos/role.dart';

final GetIt sl = GetIt.instance; //service locator

Future<void> initPlugins() async {
  await Firebase.initializeApp();

  _setupLocator();
}

void _setupLocator() {
  sl.registerSingleton(RoleRepository());
}
