import 'dart:collection';

import 'package:charts_common/common.dart' as common;
import 'package:charts_flutter/flutter.dart' as flutter;
import 'package:flutter/widgets.dart';

import 'chart.dart';
import 'pan_and_zoom_behaviour.dart';
import 'common_staged_chart.dart';
import 'time_series_data.dart';

export 'package:charts_common/common.dart' show Series, OrdinalViewport, DateTimeExtents;

///Viewport`s bounds as [Series.data] indexes.
class ViewportBounds {
  ///Left viewport`s bound.
  late int _startIndex;
  int get startIndex => _startIndex;

  ///Right viewport`s bound.
  late int _endIndex;
  int get endIndex => _endIndex;

  void setIndexes(int startIndex, int endIndex) {
    _startIndex = startIndex;
    _endIndex = endIndex;
  }

  int get datumAmountInViewport => _endIndex - _startIndex;

  @override
  toString() => '\n' 'start: $startIndex, end: $endIndex';
}

class TimeSeriesChart extends StatefulWidget {
  const TimeSeriesChart({
    required this.seriesList,
    required this.viewport, //must be required because of [autoViewport]
    Key? key,
  }) : super(key: key);

  final common.DateTimeExtents viewport;
  final List<common.Series<TimeSeries, DateTime>> seriesList;

  @override
  State<TimeSeriesChart> createState() => _TimeSeriesChartState();
}

class _TimeSeriesChartState extends State<TimeSeriesChart> {
  late List<common.Series<TimeSeries, DateTime>> seriesList = widget.seriesList;

  void refreshChart(List<TimeSeries> newData) {
    setState(() {
      seriesList = buildSeries(newData);
    });
  }

  @override
  Widget build(BuildContext context) {
    return _TimeSeriesChart(
      refreshCallback: refreshChart,
      seriesList: seriesList,
      // domainAxis: common.DateTimeAxisSpec(viewport: widget.viewport),
      behaviors: [
        FlutterPanAndZoomBehavior<DateTime>(
          commonBehavior: CommonPanAndZoomBehavior<DateTime>(
            refreshDataCallaback: refreshChart,
          ),
        )
      ],
    );
  }
}

class _TimeSeriesChart extends flutter.TimeSeriesChart {
  late final StagedTimeSeriesChart commonChart = StagedTimeSeriesChart(
    stage: Stage(),
    layoutConfig: layoutConfig?.commonLayoutConfig,
    primaryMeasureAxis: primaryMeasureAxis?.createAxis(),
    secondaryMeasureAxis: secondaryMeasureAxis?.createAxis(),
    disjointMeasureAxes: createDisjointMeasureAxes(),
    dateTimeFactory: dateTimeFactory,
  );

  final void Function(List<TimeSeries>) refreshCallback;

  _TimeSeriesChart({
    required this.refreshCallback,
    required List<common.Series<TimeSeries, DateTime>> seriesList,
    bool? animate,
    Duration? animationDuration,
    common.AxisSpec? domainAxis,
    common.NumericAxisSpec? primaryMeasureAxis,
    common.NumericAxisSpec? secondaryMeasureAxis,
    LinkedHashMap<String, common.NumericAxisSpec>? disjointMeasureAxes,
    List<common.SeriesRendererConfig<DateTime>>? customSeriesRenderers,
    List<flutter.ChartBehavior<DateTime>>? behaviors,
    List<flutter.SelectionModelConfig<DateTime>>? selectionModels,
    flutter.LayoutConfig? layoutConfig,
    common.DateTimeFactory? dateTimeFactory,
    bool? defaultInteractions,
    bool? flipVerticalAxis,
    flutter.UserManagedState<DateTime>? userManagedState,
  }) : super(
          seriesList,
          animate: animate ?? false,
          animationDuration: animationDuration,
          domainAxis: domainAxis,
          primaryMeasureAxis: primaryMeasureAxis,
          secondaryMeasureAxis: secondaryMeasureAxis,
          disjointMeasureAxes: disjointMeasureAxes,
          customSeriesRenderers: customSeriesRenderers,
          behaviors: behaviors,
          selectionModels: selectionModels,
          layoutConfig: layoutConfig,
          defaultInteractions: defaultInteractions ?? true,
          flipVerticalAxis: flipVerticalAxis,
          userManagedState: userManagedState,
          dateTimeFactory: dateTimeFactory,
        );

  bool initialized = false;

  @override
  common.TimeSeriesChart createCommonChart(_) => commonChart
    ..addLifecycleListener(
      common.LifecycleListener(onData: (_) {
        if (initialized) return;

        commonChart.domainAxis!.setViewportSettings(
          commonChart.stage.params.minScalingFactor,
          commonChart.domainAxis!.viewportTranslatePx,
        );

        initialized = true;
      }),
    );
}
