// ignore_for_file: unused_import

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hvac_remote_client/experiments/chart/time_series_data.dart';
import 'package:hvac_remote_client/experiments/data_managing.dart';
import 'package:hvac_remote_client/experiments/test_data/data_builder.dart';
import 'package:hvac_remote_client/experiments/test_data/file_manager.dart';
import 'package:hvac_remote_client/experiments/test_data/io_json.dart';
import 'package:hvac_remote_client/experiments/test_data/stage.dart';

void main() async {
  test('plug', () {});

  // mainTest();
  // await FileManager.cleanData();
  // await writeCase();
  // await readCase();
  // final data = await DataRepository.instance.startData();
  // print(data);
}

void mainTest() {
  test('TimeSeries hashCode', () {
    const valuesAmount = 1000;
    const datesAmount = 100;

    final timeStamps = <TimeSeries>[];

    for (var i = 0; i < valuesAmount; i++) {
      for (var j = 0; j < datesAmount; j++) {
        timeStamps.add(TimeSeries(
          value: i,
          usSinceEpoch: j,
        ));
      }
    }

    final uniques = timeStamps.toSet().toList();

    expect(uniques.length, timeStamps.length);
  });
}
