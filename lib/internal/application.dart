import 'package:flutter/material.dart';
import 'package:my_mqtt/domain/app_domain_mediator.dart';
import 'package:my_mqtt/domain/domain_components/authentication_component.dart';
import 'package:my_mqtt/domain/domain_components/dataflow_component.dart';
import 'package:my_mqtt/domain/domain_components/internet_component.dart';
import 'package:my_mqtt/domain/domain_components/server_connection_component.dart';
import 'package:my_mqtt/domain/domain_components/version_control_component.dart';
import 'package:my_mqtt/presentation/pages/password_page.dart';
import 'package:my_mqtt/presentation/pages/test_page.dart';
import 'package:my_mqtt/presentation/pages/unknown_page.dart';
import 'package:provider/provider.dart';

class Application extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //!it is critical part of domain layer. be careful
    final AppDomainMediator mediator = AppDomainMediator();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthComponent>(create: (context) => mediator.authComponent),
        ChangeNotifierProvider<InternetComponent>(create: (context) => mediator.connectionComponent),
        ChangeNotifierProvider<VersionControlComponent>(create: (context) => mediator.versionControlComponent),
        ChangeNotifierProvider<ServerConnectionComponent>(create: (context) => mediator.serverConnectionComponent),
        ChangeNotifierProvider<DataflowComponent>(create: (context) => mediator.dataflowComponent),
      ],
      child: MaterialApp(
        title: 'MQTT Testing',
        routes: {
          '/PasswordPage': (context) => PasswordPage(),
          '/UnknownPage': (context) => UnknownPage(),
          '/TestPage': (context) => TestPage(),
        },
        initialRoute: '/PasswordPage',
      ),
    );
  }
}
