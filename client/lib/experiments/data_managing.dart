import 'package:flutter/material.dart';
import 'package:hvac_remote_client/experiments/test_data/io_json.dart';
import 'package:hvac_remote_client/experiments/test_data/stage.dart';

import 'test_data/data_builder.dart';
import 'test_data/file_manager.dart';

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
            children: const [
              TextButton(onPressed: fullRebuild, child: Text('full rebuild')),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> fullRebuild() async {
  await FileManager.cleanData();
  await writeCase();
  await readCase();
}

Future<void> writeCase() async {
  await DataBuilder.build();
}

Future<void> readCase() async {
  final stage = stages[0];
  final file = (await FileManager.getFiles(stage)).first;
  final firstValueTimeStamp = FileManager.timeStampOf(file);
  final timeSeries = stage.deoptimize(await IOJson.read(file), firstValueTimeStamp);
  print(timeSeries.first);
}
