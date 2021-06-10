import 'package:flutter/material.dart';
import 'package:my_mqtt/presentation/pages/before_auth/account_create/page.dart';
import 'package:my_mqtt/presentation/pages/before_auth/enter.dart';
import 'package:my_mqtt/presentation/pages/before_auth/init/page.dart';
import 'package:my_mqtt/presentation/pages/before_auth/signing/page.dart';
import 'package:my_mqtt/presentation/pages/common/home.dart';
import 'package:my_mqtt/presentation/pages/settings/change_role/page.dart';
import 'package:my_mqtt/presentation/pages/settings/settings/page.dart';

Map<String, Widget Function(BuildContext)> routes = {
  // before auth
  RoutesNames.init: (_) => const InitPage(),
  RoutesNames.enter: (_) => const EnterPage(),
  RoutesNames.signIn: (_) => const SigningPage(),
  RoutesNames.accountCreate: (_) => const AccountCreatePage(),
  // common
  RoutesNames.home: (_) => const HomePage(),
  RoutesNames.settings: (_) => const SettingsPage(),
  //settings
  RoutesNames.roleChange: (_) => const RoleChangePage(),
};

class RoutesNames {
  RoutesNames._();
  //before auth
  static const String init = '/init';
  static const String enter = '/enter';
  static const String signIn = '/signIn';
  static const String accountCreate = '/createAccount';
  //common
  static const String home = '/home';
  static const String settings = '/settings';
  //settings
  static const String roleChange = '/roleChange';
}
