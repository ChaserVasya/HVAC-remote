import 'package:flutter/material.dart';
import 'package:hvac_remote_client/application/navigator.dart';
import 'package:hvac_remote_client/presentation/view_model/role.dart';
import 'package:hvac_remote_client/presentation/page/before_auth/account_create/view_model.dart';
import 'package:hvac_remote_client/presentation/page/before_auth/signing/view_model.dart';
import 'package:hvac_remote_client/presentation/page/settings/change_role/view_model.dart';

import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'routes.dart';

class Application extends StatelessWidget {
  const Application({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: _providers,
      child: MaterialApp(
        navigatorKey: navigatorKey,
        title: 'HVAC remote',
        initialRoute: RoutesNames.init,
        routes: routes,
      ),
    );
  }
}

final List<SingleChildWidget> _providers = [
  //app layer
  ChangeNotifierProvider<RoleViewModel>(create: (_) => RoleViewModel()),
  //before auth
  ChangeNotifierProvider<SigningViewModel>(create: (_) => SigningViewModel()),
  ChangeNotifierProvider<AccountCreateViewModel>(create: (_) => AccountCreateViewModel()),
  //common
  ChangeNotifierProvider<AccountCreateViewModel>(create: (_) => AccountCreateViewModel()),
  //settings
  ChangeNotifierProvider<ChangeRoleViewModel>(create: (_) => ChangeRoleViewModel()),
];
