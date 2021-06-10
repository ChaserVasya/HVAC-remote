import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_mqtt/application/application.dart';

void main() {
  _setRunAppPresets();
  //! rest initialiations are in [InitPage]
  runApp(const Application());
}

void _setRunAppPresets() {
  WidgetsFlutterBinding.ensureInitialized();

  //changed on some pages
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  //TODO define flutter error handler (e.g. log or send errors) by Crashlytics
  //FlutterError.onError = (details) => print('flutter error');
}

//TODO delete all print() before release

//TODO create issue that Dart Analyzer (right?) doesn't offer to import extensions (e.g [watch]). I have to import them manually
