import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';

import 'common_staged_chart.dart';

import '../test/test_data/int_random.dart';

class TimeSeries {
  final int millisecondsSinceEpoch;
  final int value;

  const TimeSeries({required this.value, required this.millisecondsSinceEpoch});

  DateTime get dateTime => DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch);

  @override
  String toString() => jsonEncode(toJson());

  //JSON

  Json toJson() => {
        'value': value,
        'millisecondsSinceEpoch': millisecondsSinceEpoch,
      };

  TimeSeries.fromJson(Json json)
      : value = json['value'],
        millisecondsSinceEpoch = json['millisecondsSinceEpoch'];
}

class DataRepository {
  static DataRepository? _instance;
  static DataRepository get instance => _instance ??= DataRepository._();
  DataRepository._();

  static const _fileName = 'time_series_data.json';

  final StagedTimeSeries _timeSeries = DataBuilder.build();

  //  StagedTimeSeries _initTimeSeries() {
  // final dir = await getTemporaryDirectory();
  // final file = File('${dir.path}/$_fileName');

  // final isExist = await file.exists();

  // final reader = file.openRead().transform(utf8.decoder).transform(const JsonDecoder());

  // reader.take(count);
  // if (isExist) return file;
  // file.length();

  //   return _DataBuilder.build();
  // }

  List<TimeSeries> get startData {
    const startDataAmount = 30;

    final startStageData = _timeSeries[0]!;
    final center = startStageData.length / 2;

    return startStageData
        .getRange(
          (center - startDataAmount / 2).toInt(),
          (center + startDataAmount / 2).toInt() + 1,
        )
        .toList();
  }

  ///[endPoint] can be negative, representing backing in time from reference point.
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

  //TODO check cases, when there is not requested stage (-1,-2, 1000, etc.).
  List<TimeSeries> getDataByRange({
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
}

///[Random.nextInt()] is slow. This class generates fixed random int list and
///just gives the ready int from it. It is faster.

class DataBuilder {
  //TODO monthes have different amount of days. What is the best way to merge them?
  static const List<int> _datumPerAveraging = [
    DateTime.monthsPerYear,
    DateTime.daysPerWeek * 4,
    Duration.hoursPerDay,
    Duration.minutesPerHour,
    Duration.secondsPerMinute ~/ _timeStepSec,
  ];

  static const int _timeStepSec = 200;

  static Map<int, List<TimeSeries>> build() {
    final int _firstStageLength = pow(10, 7.5).toInt();
    final Map<int, List<TimeSeries>> _timeSeries = {};

    final intGenerator = SimplifiedIntRandom();

    _timeSeries[Stage.max] = List.generate(
      _firstStageLength,
      (i) => TimeSeries(
        value: intGenerator.next(),
        millisecondsSinceEpoch: i * _timeStepSec,
      ),
      growable: false,
    );

    // _timeSeries[Stage.max] = List.generate(
    //   _firstStageLength,
    //   (i) => TimeSeries(
    //     value: Random().nextInt(100),
    //     seconds: i * _timeStepSec,
    //   ),
    // );

    for (int newStageIndex = Stage.max - 1; newStageIndex >= 0; newStageIndex--) {
      final averagingDataStage = _timeSeries[newStageIndex + 1]!;
      final newStageLength = averagingDataStage.length ~/ _datumPerAveraging[newStageIndex];

      _timeSeries[newStageIndex] = List.generate(newStageLength, (averagedValueIndex) {
        final batchStart = averagedValueIndex * _datumPerAveraging[newStageIndex];
        final batchEnd = (averagedValueIndex + 1) * _datumPerAveraging[newStageIndex];
        return _average(averagingDataStage.getRange(batchStart, batchEnd));
      });
      print('next stage generated');
    }
    print('builded');
    return _timeSeries;
  }

  static TimeSeries _average(Iterable<TimeSeries> timeSeries) {
    final averageValue = timeSeries
            .map<num>((e) => e.value) //
            .reduce((sum, e) => sum + e) //
        /
        timeSeries.length;

    // final averageTimeData = DateTime.fromMillisecondsSinceEpoch(
    //   timeSeries
    //           .map<num>((e) => e.dateTime.millisecondsSinceEpoch) //
    //           .reduce((sum, e) => sum + e) //
    //       ~/
    //       timeSeries.length,
    // );

    final averageSeconds = timeSeries
            .map<num>((e) => e.millisecondsSinceEpoch) //
            .reduce((sum, e) => sum + e) //
        ~/
        timeSeries.length;

    // return TimeSeries(
    //   value: averageValue.toInt(),
    //   dateTime: averageTimeData,
    // );
    return TimeSeries(
      value: averageValue.toInt(),
      millisecondsSinceEpoch: averageSeconds,
    );
  }
}

typedef StagedTimeSeries = Map<int, List<TimeSeries>>;
typedef Json = Map<String, dynamic>;
