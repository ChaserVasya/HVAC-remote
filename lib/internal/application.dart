import 'package:flutter/material.dart';
import 'package:my_mqtt/domain/state/author_page_state.dart';
import 'package:my_mqtt/domain/state/password_page_domain.dart';
import 'package:my_mqtt/domain/state/pid_page_state.dart';
import 'package:my_mqtt/domain/state/sensors_page_state.dart';
import 'package:provider/provider.dart';

import '../presentation/pages/author_page.dart';
import '../presentation/pages/password_page/password_page.dart';
import '../presentation/pages/pid_page/pid_page.dart';
import '../presentation/pages/sensors_page.dart';

class Application extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<PidPageState>(create: (context) => PidPageState()),
        ChangeNotifierProvider<SensorsPageState>(create: (context) => SensorsPageState()),
        ChangeNotifierProvider<AuthorPageState>(create: (context) => AuthorPageState()),
        ChangeNotifierProvider<PasswordPageDomain>(create: (context) => PasswordPageDomain()),
      ],
      child: MaterialApp(
        title: 'MQTT Testing',
        routes: _generateRoutes(),
        initialRoute: pagesNames[Pages.PasswordPage],
      ),
    );
  }

  Map<String, Widget Function(BuildContext)> _generateRoutes() {
    Map<String, Widget Function(BuildContext)> routes = {};
    for (Pages page in Pages.values) {
      switch (page) {
        case Pages.SensorsPage:
          routes.addAll({pagesNames[Pages.SensorsPage]: (context) => SensorsPage()});
          break;
        case Pages.PasswordPage:
          routes.addAll({pagesNames[Pages.PasswordPage]: (context) => PasswordPage()});
          break;
        case Pages.PidPage:
          routes.addAll({pagesNames[Pages.PidPage]: (context) => PidPage()});
          break;
        case Pages.AuthorPage:
          routes.addAll({pagesNames[Pages.AuthorPage]: (context) => AuthorPage()});
          break;
        default:
          assert(routes.containsKey(page));
      }
    }
    return routes;
  }
}

final Map<Pages, String> pagesNames = Map.fromIterable(
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
