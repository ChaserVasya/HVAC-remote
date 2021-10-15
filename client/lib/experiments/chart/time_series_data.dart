import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hvac_remote_client/experiments/test_data/data_builder.dart';
import 'package:hvac_remote_client/experiments/test_data/stage.dart';
import 'package:hvac_remote_client/experiments/test_data/stage_data.dart';

class TimeSeries {
  final int usSinceEpoch;
  final int value;

  const TimeSeries({required this.value, required this.usSinceEpoch});

  DateTime get dateTime => DateTime.fromMicrosecondsSinceEpoch(usSinceEpoch);

  @override
  String toString() => jsonEncode(toReadableJson());

  //JSON

  Json toReadableJson() => {
        'value': value,
        'dateTime': dateTime.toString(),
      };

  TimeSeries.fromReadableJson(Json json)
      : value = json['value'],
        usSinceEpoch = DateTime.parse(json['dateTime']).microsecondsSinceEpoch;

  Json toJson() => {
        'value': value,
        'usSinceEpoch': usSinceEpoch,
      };

  TimeSeries.fromJson(Json json)
      : value = json['value'],
        usSinceEpoch = json['usSinceEpoch'];

  @override
  operator ==(Object other) {
    return (other is TimeSeries) && (value == other.value) && (usSinceEpoch == other.usSinceEpoch);
  }

  @override
  int get hashCode => Object.hash(usSinceEpoch, value);
}

class DataRepository {
  static DataRepository? _instance;
  static DataRepository get instance => _instance ??= DataRepository._();
  DataRepository._();

  Future<List<TimeSeries>> startData({bool refresh = false}) async {
    if (refresh) await DataBuilder.build();
    final stage = stages[0];
    final requestedRange = DateTimeRange(start: DateTime(0), end: DateTime(3000));
    return await StageData.getRange(stage, requestedRange);
  }

  //TODO check cases, when there is not requested stage (-1,-2, 1000, etc.).
  Future<List<TimeSeries>> getDataByRange({
    required int stageIndex,
    required DateTimeRange range,
    int? limit,
  }) async {
    return await StageData.getRange(stages[stageIndex], range, limit);
  }
}

typedef StagedTimeSeries = Map<int, List<TimeSeries>>;
typedef Json = Map<String, dynamic>;
