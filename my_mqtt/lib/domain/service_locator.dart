import 'package:get_it/get_it.dart';
import 'package:my_mqtt/data/auth_service.dart';
import 'package:my_mqtt/data/repositories/config_repository.dart';
import 'package:my_mqtt/data/repositories/user_repository.dart';

final GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerSingleton<UserRepository>(UserRepository());
  locator.registerSingleton<ConfigRepository>(ConfigRepository());
  locator.registerSingleton<Auth>(Auth());
}
