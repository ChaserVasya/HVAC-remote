import 'dart:math';

import 'package:flutter/material.dart';

import 'common_staged_chart.dart';
import 'pan_and_zoom_behaviour.dart';

class TimeSeries {
  final DateTime dateTime;
  final num value;

  const TimeSeries({required this.value, required this.dateTime});

  @override
  String toString() => '\n' '$dateTime: $value';
}

class DataProvider {
  static const int maxStageIndex = 4;
  static const int datumPerAveraging = 5;

  final int _firstStageLength = pow(10, 6).toInt();

  List<TimeSeries> get startData {
    const startDataAmount = CommonPanAndZoomBehavior.maxDataForChart;

    final startStageData = _timeSeries[0]!;
    final center = startStageData.length / 2;

    return startStageData
        .getRange(
          (center - startDataAmount / 2).toInt(),
          (center + startDataAmount / 2).toInt() + 1,
        )
        .toList();
  }

  //TODO refactor min-max-chain: min(max(min(...)))
  //TODO check docs correctness
  ///[endPoint] can be negative, representing backing in time from reference
  ///point.
  List<TimeSeries> getDataAroundPoint({
    required int stageIndex,
    required int datumAmount,
    required DateTime newChartCenter,
  }) {
    final dataList = _timeSeries[stageIndex]!;
    final centerIndex = _binarySearchOfNearest(dataList, newChartCenter);

    final startIndex = min(max((centerIndex - datumAmount ~/ 2), 0), dataList.length);
    final endIndex = min(max((centerIndex + datumAmount ~/ 2), 0), dataList.length);

    return dataList.getRange(startIndex, endIndex + 1).toList();
  }

  List<TimeSeries> getDataByRange({
    //TODO check cases, when there is not requested stage (-1,-2, 1000, etc.).
    required int stageIndex,
    required DateTimeRange range,
    int? limit,
  }) {
    final start = _binarySearchOfNearest(_timeSeries[stageIndex]!, range.start);
    final preEnd = _binarySearchOfNearest(_timeSeries[stageIndex]!, range.end);
    final end = (limit != null) ? min(start + limit, preEnd) : preEnd;
    return _timeSeries[stageIndex]!.getRange(start, end + 1).toList();
  }

  int _binarySearchOfNearest(List<TimeSeries> sortedList, DateTime value) {
    int min = 0;
    int max = sortedList.length;
    int mid = -1;
    while (min < max) {
      mid = min + ((max - min) >> 1);
      final int comp = sortedList[mid].dateTime.compareTo(value);
      if (comp == 0) break; //exact
      if (comp < 0) {
        min = mid + 1;
      } else {
        max = mid;
      }
    }
    return mid; //nearest from bottom
  }

  static DataProvider? _instance;
  static DataProvider get instance => _instance ??= DataProvider._();

  DataProvider._() {
    _timeSeries[maxStageIndex] = List.generate(
      _firstStageLength,
      (i) => TimeSeries(
        value: Random().nextInt(100),
        dateTime: DateTime(2000, 1, 1, 0, 0, i * 10),
      ),
    );

    for (int newStageIndex = maxStageIndex - 1; newStageIndex >= 0; newStageIndex--) {
      final averagingDataStage = _timeSeries[newStageIndex + 1]!;
      final newStageLength = averagingDataStage.length ~/ datumPerAveraging;

      _timeSeries[newStageIndex] = List.generate(newStageLength, (averagedValueIndex) {
        final batchStart = averagedValueIndex * datumPerAveraging;
        final batchEnd = (averagedValueIndex + 1) * datumPerAveraging;
        return _average(averagingDataStage.getRange(batchStart, batchEnd));
      });
    }
  }

  TimeSeries _average(Iterable<TimeSeries> timeSeries) {
    final averageValue = timeSeries
            .map<num>((e) => e.value) //
            .reduce((sum, e) => sum + e) //
        /
        timeSeries.length;

    final averageTimeData = DateTime.fromMillisecondsSinceEpoch(
      timeSeries
              .map<num>((e) => e.dateTime.millisecondsSinceEpoch) //
              .reduce((sum, e) => sum + e) //
          ~/
          timeSeries.length,
    );

    return TimeSeries(
      value: averageValue,
      dateTime: averageTimeData,
    );
  }

  final Map<int, List<TimeSeries>> _timeSeries = {};
}
