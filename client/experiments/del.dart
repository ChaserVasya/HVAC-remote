import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

void main() => runApp(const _MyApp());

class _MyApp extends StatelessWidget {
  const _MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: const Locale('ru'),
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(onPressed: () => save(), child: const Text('save')),
              TextButton(onPressed: () => load(), child: const Text('load')),
              TextButton(onPressed: () => delete(), child: const Text('delete')),
            ],
          ),
        ),
      ),
    );
  }
}

const String relPath = 'testFile.txt';

void save() async {
  final dir = await getTemporaryDirectory();
  final file = File('${dir.path}/$relPath');
  for (var i = 1; i < 3; i++) file.writeAsStringSync('1\n', mode: FileMode.writeOnlyAppend);
  print('saved');
}

void load() async {
  final dir = await getTemporaryDirectory();
  final file = File('${dir.path}/$relPath');
  final data = file.readAsLinesSync();
  print(data);
}

void delete() async {
  final dir = await getTemporaryDirectory();
  final file = File('${dir.path}/$relPath');
  if (!file.existsSync()) return print('not exist');
  file.deleteSync();
  print('deleted');
}
