import 'dart:collection';

import 'package:charts_common/common.dart' as common;
import 'package:charts_flutter/flutter.dart' as flutter;
import 'package:flutter/widgets.dart';

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

class TimeSeriesChart extends StatelessWidget {
  const TimeSeriesChart({
    required this.seriesList,
    required this.viewport, //must be required because of [autoViewport]
    Key? key,
  }) : super(key: key);

  final List<common.Series<TimeSeries, DateTime>> seriesList;
  final common.DateTimeExtents viewport;

  @override
  Widget build(BuildContext context) {
    return _TimeSeriesChart(
      seriesList: seriesList,
      defaultRenderer: _ProxyBarRendererConfig<DateTime>(),
      domainAxis: common.DateTimeAxisSpec(viewport: viewport),
      behaviors: [
        FlutterPanAndZoomBehavior<DateTime>(
          commonBehavior: CommonPanAndZoomBehavior<DateTime>(),
        )
      ],
    );
  }
}

class _TimeSeriesChart extends flutter.TimeSeriesChart {
  late final StagedTimeSeriesChart commonChart = StagedTimeSeriesChart(
    data: seriesList.single.data as List<TimeSeries>,
    stage: Stage(),
    bounds: (defaultRenderer as _ProxyBarRendererConfig<DateTime>).bounds,
    layoutConfig: layoutConfig?.commonLayoutConfig,
    primaryMeasureAxis: primaryMeasureAxis?.createAxis(),
    secondaryMeasureAxis: secondaryMeasureAxis?.createAxis(),
    disjointMeasureAxes: createDisjointMeasureAxes(),
    dateTimeFactory: dateTimeFactory,
  );

  //'As' because we expected injected proxy renderer.
  ///Viewport`s bounds as [Series.data] indexes.
  ViewportBounds get bounds => (defaultRenderer as _ProxyBarRendererConfig).bounds;

  _TimeSeriesChart({
    required List<common.Series<TimeSeries, DateTime>> seriesList,
    bool? animate,
    Duration? animationDuration,
    common.AxisSpec? domainAxis,
    common.NumericAxisSpec? primaryMeasureAxis,
    common.NumericAxisSpec? secondaryMeasureAxis,
    LinkedHashMap<String, common.NumericAxisSpec>? disjointMeasureAxes,
    required _ProxyBarRendererConfig<DateTime> defaultRenderer,
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
          animate: animate,
          animationDuration: animationDuration,
          domainAxis: domainAxis,
          primaryMeasureAxis: primaryMeasureAxis,
          secondaryMeasureAxis: secondaryMeasureAxis,
          disjointMeasureAxes: disjointMeasureAxes,
          defaultRenderer: defaultRenderer,
          customSeriesRenderers: customSeriesRenderers,
          behaviors: behaviors,
          selectionModels: selectionModels,
          layoutConfig: layoutConfig,
          defaultInteractions: defaultInteractions ?? true,
          flipVerticalAxis: flipVerticalAxis,
          userManagedState: userManagedState,
          dateTimeFactory: dateTimeFactory,
        );

  @override
  common.TimeSeriesChart createCommonChart(_) => commonChart;
}

///Needed indexes are computed in super only like intermediate value
///between methods. Here we intercept indexes during routine work.
class _ProxyBarRenderer<D> extends common.BarRenderer<D> {
  final ViewportBounds bounds;

  _ProxyBarRenderer(_ProxyBarRendererConfig<D> config)
      : bounds = config.bounds,
        super.internal(
          config: config,
          rendererId: common.SeriesRenderer.defaultRendererId,
        );

  ///Intersepts indexes.
  @override
  void addMeasureValuesFor(var _, var __, int startIndex, int endIndex) {
    bounds.setIndexes(startIndex, endIndex);
    super.addMeasureValuesFor(_, __, startIndex, endIndex);
  }
}

///Provides proxy renderer.
class _ProxyBarRendererConfig<D> extends common.BarRendererConfig<D> {
  final ViewportBounds bounds = ViewportBounds();

  ///Injects the proxy renderer.
  @override
  common.BarRenderer<D> build() => _ProxyBarRenderer<D>(this);
}
