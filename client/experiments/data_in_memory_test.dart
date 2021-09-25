import 'package:flutter/material.dart';

import '../test/things_test.dart';

class _MyApp extends StatelessWidget {
  const _MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: const Locale('ru'),
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextButton(
                  child: const Text('start sodomia'),
                  onPressed: ()=> startScenario();
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> startScenario()async {
  await saveCase();
  await readCase();
}