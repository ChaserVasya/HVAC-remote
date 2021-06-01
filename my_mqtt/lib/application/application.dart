import 'package:flutter/material.dart';
import 'package:my_mqtt/presentation/auth/pages/account_create.dart';
import 'package:my_mqtt/presentation/auth/pages/login.dart';
import 'package:my_mqtt/presentation/auth/view_model.dart';
import 'package:my_mqtt/presentation/auth/enter_page.dart';
import 'package:my_mqtt/presentation/init_page.dart';
import 'package:my_mqtt/presentation/routes_names.dart';
import 'package:provider/provider.dart';

class Application extends StatelessWidget {
     
  const Application(this.navigatorKey, {Key? key}) : super(key: key);

  final GlobalKey<NavigatorState> navigatorKey;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthViewModel>(create: (_) => AuthViewModel()),
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        title: 'MQTT Testing',
        initialRoute: RoutesNames.init,
        routes: {
          RoutesNames.init: (_) =>  const InitPage(),
          //
          RoutesNames.beforeAuth.enter: (_) => EnterPage(),
          RoutesNames.beforeAuth.login: (_) => LogingPage(),
          RoutesNames.beforeAuth.accountCreate: (_) => AccountCreatePage(),
          //
          RoutesNames.afterAuth.homePage: = (_) => HomePage(),
        },
      ),
    );
  }
}
