import 'package:flutter/material.dart';
import 'package:my_mqtt/application/routes_names.dart';
import 'package:my_mqtt/application/service_locator.dart';
import 'package:my_mqtt/presentation/templates/page_template.dart';

class InitPage extends StatefulWidget {
  const InitPage({Key? key}) : super(key: key);

  @override
  _InitPageState createState() => _InitPageState();
}

class _InitPageState extends State<InitPage> {
  bool _pluginsAreSetuped = false;

  @override
  void initState() {
    onPluginsSetup() => setState(() => _pluginsAreSetuped = true);

    //! not at main because [ZonedExceptionHandler] needed
    //! in builded  [Navigator] to show [AlertDialog]
    initPlugins(onPluginsSetup);

    //TODO delete on release
    //Future.delayed(const Duration(seconds: 5), onPluginsSetup);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_pluginsAreSetuped) {
      Future.microtask(() => Navigator.of(context).pushReplacementNamed(RoutesNames.enter));
    }
    return const PageTemplate(
      afterAuth: false,
      body: CircularProgressIndicator(),
    );
  }
}
