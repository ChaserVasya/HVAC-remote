import 'package:flutter/material.dart';
import 'package:my_mqtt/application/service_locator.dart';

///Initializations except presentation-layer
Future<void> initPlugins(void Function() onPluginsSetup) async {
  //TODO define flutter error handler (e.g. log or send errors)
  //FlutterError.onError = (details) => print('flutter error');

  await initServices();
}
