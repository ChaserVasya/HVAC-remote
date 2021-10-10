import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

main() => runApp(const _MyApp());

class _MyApp extends StatelessWidget {
  const _MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      locale: Locale('ru'),
      home: Scaffold(
        body: Padding(
          padding: EdgeInsets.all(20.0),
          child: Center(
            child: TextButton(
              onPressed: doSomething,
              child: Text('do'),
            ),
          ),
        ),
      ),
    );
  }
}

void doSomething() async {
  getExternalStorageDirectory();
}
