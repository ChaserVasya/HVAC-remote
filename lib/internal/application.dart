import 'package:flutter/material.dart';
import 'package:my_mqtt/domain/state/author_page_state.dart';
import 'package:my_mqtt/domain/state/password_page_state.dart';
import 'package:my_mqtt/domain/state/pid_page_state.dart';
import 'package:my_mqtt/domain/state/sensors_page_state.dart';
import 'package:provider/provider.dart';

import '../presentation/pages/author_page.dart';
import '../presentation/pages/password_page.dart';
import '../presentation/pages/pid_page.dart';
import '../presentation/pages/sensors_page.dart';

class Application extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<PidPageState>(create: (context) => PidPageState()),
        ChangeNotifierProvider<SensorsPageState>(create: (context) => SensorsPageState()),
        ChangeNotifierProvider<AuthorPageState>(create: (context) => AuthorPageState()),
        ChangeNotifierProvider<PasswordPageState>(create: (context) => PasswordPageState()),
      ],
      child: MaterialApp(
        title: 'MQTT Testing',
        routes: _generateRoutes(),
        initialRoute: pageNames[Pages.PasswordPage],
      ),
    );
  }

  Map<String, Widget Function(BuildContext)> _generateRoutes() {
    Map<String, Widget Function(BuildContext)> routes = {};
    for (Pages page in Pages.values) {
      switch (page) {
        case Pages.SensorsPage:
          routes.addAll({pageNames[Pages.SensorsPage]: (context) => SensorsPage()});
          break;
        case Pages.PasswordPage:
          routes.addAll({pageNames[Pages.PasswordPage]: (context) => PasswordPage()});
          break;
        case Pages.PidPage:
          routes.addAll({pageNames[Pages.PidPage]: (context) => PidPage()});
          break;
        case Pages.AuthorPage:
          routes.addAll({pageNames[Pages.AuthorPage]: (context) => AuthorPage()});
          break;
      }
    }
    return routes;
  }
}

final Map<Pages, String> pageNames = Map.fromIterable(
  Pages.values,
  key: (page) => page,
  value: (page) => '/${page.toString().split('.').last}',
);

enum Pages {
  SensorsPage,
  PasswordPage,
  PidPage,
  AuthorPage,
}
