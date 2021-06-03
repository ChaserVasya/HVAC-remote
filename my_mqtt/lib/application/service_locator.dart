import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';

final GetIt sl = GetIt.instance; //service locator

Future<void> initPlugins([void Function()? onPluginsSetup]) async {
  await Firebase.initializeApp();

  _setupLocator();

  if (onPluginsSetup != null) onPluginsSetup();
}

void _setupLocator() {
  //TODO setup  repos end ets
}
