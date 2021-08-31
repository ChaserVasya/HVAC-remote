import 'dart:collection';

import 'package:charts_common/common.dart' as common show TimeSeriesChart;
import 'package:charts_common/common.dart';
import 'package:flutter/material.dart';

import 'pan_and_zoom_behaviour.dart';
import 'time_series_chart.dart';
import 'time_series_data.dart';

/// Stage hides stageIndex, so, all [int] are list indexes and start from 0.
class Stage {
  static const int max = 4;
  static const int min = 0;

  int _current = min;
  int get current => _current;

  ///Doesn`t change stage if [current] is boundary.
  Directions? maybeChangeStage(Directions stageChangeDir) {
    if (_current == min && stageChangeDir == Directions.decrease) return null;
    if (_current == max && stageChangeDir == Directions.increase) return null;

    switch (stageChangeDir) {
      case Directions.increase:
        ++_current;
        return Directions.increase;
      case Directions.decrease:
        --_current;
        return Directions.decrease;
    }
  }
}

class StagedTimeSeriesChart extends common.TimeSeriesChart {
  final Stage stage;

  //TODO Replace this comment in right place.
  ///During zoom proccess end always equals data end. Not viewport`s end
  final ViewportBounds bounds;

  final List<TimeSeries> data;

  StagedTimeSeriesChart({
    required this.data,
    required this.bounds,
    required this.stage,
    bool? vertical,
    LayoutConfig? layoutConfig,
    NumericAxis? primaryMeasureAxis,
    NumericAxis? secondaryMeasureAxis,
    LinkedHashMap<String, NumericAxis>? disjointMeasureAxes,
    DateTimeFactory? dateTimeFactory,
  }) : super(
          vertical: vertical,
          layoutConfig: layoutConfig,
          primaryMeasureAxis: primaryMeasureAxis,
          secondaryMeasureAxis: secondaryMeasureAxis,
          disjointMeasureAxes: disjointMeasureAxes,
          dateTimeFactory: dateTimeFactory ?? const LocalDateTimeFactory(),
        );

  ///Recenters chart
  void shiftData(int datumAmount, DateTime newChartCenter) {
    final newData = DataProvider.instance.getDataAroundPoint(
      stageIndex: stage.current,
      datumAmount: datumAmount,
      newChartCenter: newChartCenter,
    );
    data
      ..clear()
      ..addAll(newData);
  }

  void refreshChartData(DateTimeRange viewportRange) {
    final newData = DataProvider.instance.getDataByRange(
      stageIndex: stage.current,
      range: viewportRange,
    );
    //TODO Can I manipulate with [currentSeriesList]? Are [List]s in them the same?
    data
      ..clear()
      ..addAll(newData);
    print('stage ${stage.current} is set');
  }
}

enum Directions {
  increase,
  decrease,
}
