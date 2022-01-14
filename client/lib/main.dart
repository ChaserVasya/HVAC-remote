import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hvac_remote_client/application/application.dart';
import 'package:path_provider/path_provider.dart';

import 'mqtt_lts_test.dart';

bool setCrashlytics = false;

main() => runApp(const _MyApp());

class _MyApp extends StatelessWidget {
  const _MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Padding(
          padding: EdgeInsets.all(20.0),
          child: Center(
            child: TextButton(
              onPressed: mainCb,
              child: Text('do'),
            ),
          ),
        ),
      ),
    );
  }
}

void mainCb() async {
  final mqtt = MqttDb();
  await mqtt.connect();
}

void _main() {
  runZonedGuarded<Future<void>>(
    () async {
      await _setRunAppPresets();
      runApp(const Application());
    },
    (e, s) {
      if (setCrashlytics) {
        FirebaseCrashlytics.instance.recordError(e, s, printDetails: true);
      }
    },
  );
}

Future<void> _setRunAppPresets() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

  //changed on some pages
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  setCrashlytics = true;
}
