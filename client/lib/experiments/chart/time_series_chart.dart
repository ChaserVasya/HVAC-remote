import 'dart:collection';

import 'package:charts_common/common.dart';
import 'package:charts_common/common.dart' as common;
import 'package:charts_flutter/flutter.dart' as flutter;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'chart.dart';
import 'pan_and_zoom_behaviour.dart';
import 'common_staged_chart.dart';
import 'tick_formatter_spec.dart';
import 'tick_provider_spec.dart';
import 'time_series_data.dart';

class TimeSeriesChart extends StatefulWidget {
  const TimeSeriesChart({
    required this.seriesList,
    Key? key,
  }) : super(key: key);

  final List<Series<TimeSeries, DateTime>> seriesList;

  @override
  State<TimeSeriesChart> createState() => _TimeSeriesChartState();
}

class _TimeSeriesChartState extends State<TimeSeriesChart> {
  late List<Series<TimeSeries, DateTime>> seriesList;
  late DateTimeExtents viewport;

  void refreshChart(List<TimeSeries> newData, DateTimeRange newViewport) {
    setState(() {
      seriesList = buildSeries(newData);
      viewport = newViewport.toExtents();
    });
  }

  @override
  void initState() {
    super.initState();

    seriesList = widget.seriesList;
    viewport = initViewport(seriesList.single.data);
  }

  @override
  Widget build(BuildContext context) {
    return _TimeSeriesChart(
      seriesList: seriesList,
      // domainAxis: DateTimeAxisSpec(viewport: widget.viewport),
      domainAxis: DateTimeAxisSpec(
        viewport: viewport,
        tickProviderSpec: CustomTickProviderSpec(),
        tickFormatterSpec: CustomFormatterSpec(),
      ),
      behaviors: [
        FlutterPanAndZoomBehavior<DateTime>(
          commonBehavior: CommonPanAndZoomBehavior<DateTime>(
            refreshDataCallaback: refreshChart,
          ),
        ),
      ],
    );
  }

  DateTimeExtents initViewport(List<TimeSeries> data) {
    final minScalingFactor = Stage().params.minScalingFactor.round();

    final dataRange = data.last.dateTime.difference(data.first.dateTime);
    final center = data.first.dateTime.add(dataRange ~/ 2);

    return DateTimeExtents(
      start: center.subtract(dataRange ~/ (2 * minScalingFactor)),
      end: center.add(dataRange ~/ (2 * minScalingFactor)),
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

  _TimeSeriesChart({
    required List<Series<TimeSeries, DateTime>> seriesList,
    bool? animate,
    Duration? animationDuration,
    AxisSpec? domainAxis,
    NumericAxisSpec? primaryMeasureAxis,
    NumericAxisSpec? secondaryMeasureAxis,
    LinkedHashMap<String, NumericAxisSpec>? disjointMeasureAxes,
    List<SeriesRendererConfig<DateTime>>? customSeriesRenderers,
    List<flutter.ChartBehavior<DateTime>>? behaviors,
    List<flutter.SelectionModelConfig<DateTime>>? selectionModels,
    flutter.LayoutConfig? layoutConfig,
    DateTimeFactory? dateTimeFactory,
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

  // bool initialized = false;

  @override
  common.TimeSeriesChart createCommonChart(_) => commonChart;
  // ..addLifecycleListener(
  //   LifecycleListener(onData: (_) {
  //     if (initialized) return;

  //     commonChart.domainAxis!.setViewportSettings(
  //       commonChart.stage.params.minScalingFactor,
  //       commonChart.domainAxis!.viewportTranslatePx,
  //     );

  //     initialized = true;
  //   }),
  // );
}

extension on DateTimeRange {
  DateTimeExtents toExtents() {
    return DateTimeExtents(start: start, end: end);
  }
}
