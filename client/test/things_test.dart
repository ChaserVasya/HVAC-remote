import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider/path_provider.dart';

import '../experiments/time_series_data.dart';

void main() async {
  test('plug', () {});
  await saveCase();
  await readCase();
}

Future<void> saveCase() async {
  final dayData = generateDayData();
  await saveToPhone(jsonEncode(dayData));
}

Future<void> readCase() async {
  final deserialized = await serializeFile();
  print(deserialized.first);
}

Future<File> getTestFile() async {
  final path = (await getTemporaryDirectory()).path;
  final fullPath = path + '\\' + 'test.json';
  return File(fullPath);
}

Future<List<TimeSeries>> serializeFile() async {
  final file = await getTestFile();

  final encoded = await file.readAsString();
  final List<dynamic> objList = jsonDecode(encoded);

  final List<TimeSeries> deserializedList = [];
  for (Map<String, dynamic> json in objList) deserializedList.add(TimeSeries.fromJson(json));
  return deserializedList;
}

List<TimeSeries> generateDayData() {
  final intGenerator = CircledRandomIntList();

  final startPoint = DateTime(2021, 1, 1, 0, 0, 0).millisecondsSinceEpoch ~/ Duration.millisecondsPerSecond;

  final timeSeries = List.generate(
    Duration.secondsPerDay,
    (second) => TimeSeries(
      value: intGenerator.next(),
      secondsSinceEpoch: startPoint + second,
    ),
    growable: false,
  );

  return timeSeries;
}

Future<void> saveToPhone(String json, [bool verbose = true]) async {
  if (verbose) {
    final file = await getTestFile();

    final start = DateTime.now();
    await file.writeAsString(json);
    final end = DateTime.now();
    print('exec time, sec:  ${DateTimeRange(start: start, end: end).duration.inSeconds}');

    print('length: ${await file.length()}');
  } else {
    final file = await getTestFile();
    await file.writeAsString(json);
  }
}
