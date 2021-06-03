import 'package:flutter/material.dart';
import 'package:my_mqtt/application/service_locator.dart';
import 'package:my_mqtt/application/routes_names.dart';

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

    //! not at main because [AsyncExceptionHandler] needed
    //! in builded  [Navigator] to show [AlertDialog]
    initPlugins(onPluginsSetup);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_pluginsAreSetuped) {
      Future.microtask(() => Navigator.of(context).pushReplacementNamed(RoutesNames.init));
    }
    return const CircularProgressIndicator();
  }
}
