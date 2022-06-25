import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hvac_remote_client/application/application.dart';

void main() {
  runZonedGuarded<Future<void>>(
    () async {
      await _setRunAppPresets();
      runApp(const Application());
    },
    (e, s) {
      // FirebaseCrashlytics.instance.recordError(e, s, printDetails: true);
    },
  );
}

Future<void> _setRunAppPresets() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

  //changed on some pages
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
}
