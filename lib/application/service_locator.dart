import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';
import 'package:my_mqtt/data/auth_service.dart';
import 'package:my_mqtt/data/repositories/config_repository.dart';
import 'package:my_mqtt/data/repositories/user_repository.dart';

final GetIt sl = GetIt.instance; //service locator

Future<void> initPlugins(void Function() onPluginsSetup) async {
  await Firebase.initializeApp();

  _setupLocator();

  onPluginsSetup();
}

void _setupLocator() {
  sl.registerSingleton<FirebaseAuth>(FirebaseAuth.instance);
  sl.registerSingleton<FirebaseFirestore>(FirebaseFirestore.instance);
  sl.registerSingleton<FirebaseFunctions>(FirebaseFunctions.instance);

  // sl.registerSingleton<UserRepository>(UserRepository());
  // sl.registerSingleton<ConfigRepository>(ConfigRepository());
  // sl.registerSingleton<Auth>(Auth());
}
