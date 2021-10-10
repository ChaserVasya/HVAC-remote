import 'dart:collection';

import 'package:charts_common/common.dart' as common show TimeSeriesChart;
import 'package:charts_common/common.dart';
import 'package:flutter/material.dart';

import 'time_series_chart.dart';
import 'time_series_data.dart';

enum Directions {
  increase,
  decrease,
}

class StagedTimeSeriesChart extends common.TimeSeriesChart {
  final Stage stage;

  //TODO Replace this comment in right place.
  ///During zoom proccess end always equals data end. Not viewport`s end

  StagedTimeSeriesChart({
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

  Future<List<TimeSeries>> refreshChartData(DateTimeRange chartDataRange, [int? limit]) async {
    return await DataRepository.instance.getDataByRange(
      stageIndex: stage.current,
      range: chartDataRange,
      limit: limit,
    );
  }
}

/// Stage hides stageIndex, so, all [int] are list indexes and start from 0.
class Stage {
  static const int max = 5;
  static const int min = 0;

  static int _current = min;
  int get current => _current;

  ZoomParameters _params = _zoomParamsPerStage[min];
  ZoomParameters get params => _params;

  ///Doesn`t change stage if [current] is boundary.
  Directions? maybeChangeStage(Directions? stageChangeDir) {
    if (stageChangeDir == null) return null;

    if (_current == min && stageChangeDir == Directions.decrease) return null;
    if (_current == max && stageChangeDir == Directions.increase) return null;

    switch (stageChangeDir) {
      case Directions.increase:
        _current++;
        _params = _zoomParamsPerStage[_current];
        return Directions.increase;
      case Directions.decrease:
        _current--;
        _params = _zoomParamsPerStage[_current];
        return Directions.decrease;
    }
  }
}

class ZoomParameters {
  static const double scopeDataFactor = 2;

  late final double minScalingFactor;
  late final double maxScalingFactor;

  ///If scaling is in this zone stage changing is triggered.
  late final double stageChangeTriggeringZone;

  /// If data amount exceeds this value chart freezes.
  late final int maxDataForChart;

  /// This value is needed to avoid noise-like graphics. When is exceeded data
  /// are grouped and averaged, stage decreased.
  final int maxDataInViewport;

  /// This value is minimal comfortable and informative amount of data in
  /// viewport. If a viewport is out of this value, stage is increased, bars are
  /// splitted into more informative bars.
  final int minDataInViewport;

  ZoomParameters({
    required this.minDataInViewport,
    required this.maxDataInViewport,
  }) {
    maxDataForChart = (scopeDataFactor * maxDataInViewport).toInt();
    minScalingFactor = maxDataForChart / maxDataInViewport;
    maxScalingFactor = maxDataForChart / minDataInViewport;
    stageChangeTriggeringZone = 0.1 * (maxScalingFactor - minScalingFactor);
  }
}

//TODO synchronize n-1`th maxDataInViewport end n`th minDataInViewport automatically
final List<ZoomParameters> _zoomParamsPerStage = () {
  final secStage = ZoomParameters(
    maxDataInViewport: 120,
    minDataInViewport: 10,
  );
  final minStage = ZoomParameters(
    maxDataInViewport: 120,
    minDataInViewport: 2,
  );
  final hourStage = ZoomParameters(
    maxDataInViewport: 48,
    minDataInViewport: 2,
  );
  final dayStage = ZoomParameters(
    maxDataInViewport: 60,
    minDataInViewport: 2,
  );
  final monthStage = ZoomParameters(
    maxDataInViewport: 24,
    minDataInViewport: 2,
  );
  final yearStage = ZoomParameters(
    maxDataInViewport: 10,
    minDataInViewport: 2,
  );

  return <ZoomParameters>[
    yearStage,
    monthStage,
    dayStage,
    hourStage,
    minStage,
    secStage,
  ];
}();
