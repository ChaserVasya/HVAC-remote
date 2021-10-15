import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hvac_remote_client/experiments/chart/time_series_data.dart';
import 'package:hvac_remote_client/experiments/test_data/file_manager.dart';
import 'package:hvac_remote_client/experiments/test_data/io_json.dart';
import 'package:hvac_remote_client/experiments/test_data/stage.dart';

//TODO implement Iterable if need
class StageData {
  StageData._();

  static Future<List<TimeSeries>> getRange(
    Stage stage,
    DateTimeRange requestedRange, [
    int? limit,
  ]) async {
    final allFiles = await FileManager.getFiles(stage);

    final pullableFiles = stage.getFilesCoveredRange(allFiles, requestedRange);
    if (pullableFiles == null) return []; //TODO handle null case

    final allData = await IOJson.readAndMerge<int>(pullableFiles);

    final startTimeStamp = FileManager.timeStampOf(pullableFiles.first);
    final pullableRange = stage.getPullableRange(allData, startTimeStamp, requestedRange);
    if (pullableRange == null) return [];
    final pulledValues = stage.pullValuesWithRange(allData, startTimeStamp, pullableRange);

    final firstValueTimeStamp = stage.floorValueTimeStamp(pullableRange.start);
    final deoptimized = stage.deoptimize(pulledValues!, firstValueTimeStamp);
    return (limit == null) ? deoptimized : _narrowDownTo(limit, deoptimized);
  }

  static List<T> _narrowDownTo<T>(int amount, List<T> data) {
    final center = data.length ~/ 2;
    final start = (center - amount ~/ 2).clamp(0, center);
    final end = (center + amount ~/ 2).clamp(center, data.length - 1);
    return data.getRange(start, end + 1).toList();
  }
}
