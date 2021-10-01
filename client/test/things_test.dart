import 'dart:async';

import 'package:flutter_test/flutter_test.dart';

import '../experiments/time_series_data.dart' hide DataBuilder;
import 'test_data/file_manager.dart';
import 'test_data/data_builder.dart';
import 'test_data/io_json.dart';
import 'test_data/stage.dart';

void main() async {
  test('plug', () {});
  await FileManager.cleanData();
  await writeCase();
  await readCase();
}

Future<void> writeCase() async {
  await DataBuilder.build();
}

Future<void> readCase() async {
  final file = (await FileManager.getFiles(stages[0])).first;
  final timeSeries = deoptimize(await IOJson.read(file));
  print(timeSeries.first);
}

List<TimeSeries> deoptimize(List<int> values) {
  final timeSeries = List.generate(
    values.length,
    (sec) => TimeSeries(
      value: values[sec],
      millisecondsSinceEpoch: Stage.refPoint.millisecondsSinceEpoch + sec * Duration.millisecondsPerSecond,
    ),
    growable: false,
  );

  return timeSeries;
}
