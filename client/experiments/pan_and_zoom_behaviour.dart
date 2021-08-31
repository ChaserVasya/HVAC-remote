import 'dart:math';

import 'package:charts_common/common.dart' as common;
import 'package:charts_flutter/flutter.dart' as flutter;
import 'package:flutter/material.dart';
import 'package:meta/meta.dart' show immutable;

import 'package:charts_flutter/src/behaviors/zoom/pan_behavior.dart' as flutter;
import 'package:charts_flutter/src/behaviors/zoom/pan_and_zoom_behavior.dart' as flutter;

import 'common_staged_chart.dart';
import 'package:charts_common/src/chart/cartesian/axis/time/date_time_scale.dart';

import 'time_series_data.dart';

@immutable
class FlutterPanAndZoomBehavior<D> extends flutter.PanAndZoomBehavior<D> {
  FlutterPanAndZoomBehavior({required this.commonBehavior});

  final CommonPanAndZoomBehavior<D> commonBehavior;

  @override
  common.PanAndZoomBehavior<D> createCommonBehavior() => commonBehavior;
}

//TODO underscale text is rare. Fill underscale by text.
//TODO refactor so that the levels of abstractions stand out clearly:
// zoom, duration, datum amount, viewport. Build clear dependencies.
//TODO docs
class CommonPanAndZoomBehavior<D> extends common.PanBehavior<D>
    with flutter.FlutterPanBehaviorMixin
    implements common.PanAndZoomBehavior<D> {
  CommonPanAndZoomBehavior() {
    //assert(maxScalingFactor - minScalingFactor > 2 * stageChangeTriggeringZone);
  }
  @override
  String get role => 'PanAndZoom';

  /// Flag which is enabled to indicate that the user is "zooming" the chart.
  bool _isZooming = false;

  @override
  bool get isZooming => _isZooming;

  /// This value is minimal comfortable and informative amount of data in
  /// viewport. If a viewport is out of this value, stage is increased, bars are
  /// splitted into more informative bars.
  static const minDataInViewport = 7;

  /// This value is needed to avoid noise-like graphics. When is exceeded data
  /// are grouped and averaged, stage decreased.
  static const maxDataInViewport = minDataInViewport * DataProvider.datumPerAveraging;

  /// If data amount exceeds this value chart freezes.
  static const maxDataForChart = maxDataInViewport * 2;

  static const minScalingFactor = maxDataForChart / maxDataInViewport;
  static const maxScalingFactor = maxDataForChart / minDataInViewport;

  ///If scaling is in this zone stage changing is triggered.
  static const stageChangeTriggeringZone = 0.1 * (maxScalingFactor - minScalingFactor);

  /// Current zoom scaling factor for the behavior.
  double scalingFactorOnStart = minScalingFactor;

  @override
  bool onDragStart(Point<double> localPosition) {
    if (chart == null) return false;

    super.onDragStart(localPosition);

    scalingFactorOnStart = chart!.domainAxis!.viewportScalingFactor;
    _isZooming = true;

    return true;
  }

  @override
  bool onDragUpdate(Point<double> localPosition, double scale) {
    if (scale == 1.0) {
      _isZooming = false;
      return super.onDragUpdate(localPosition, scale);
    }

    cancelPanning();

    final chart = this.chart;
    if (!_isZooming || lastPosition == null || chart == null) return false;

    final domainAxis = chart.domainAxis;

    if (domainAxis == null) return false;

    domainAxisTickProvider.mode = common.PanningTickProviderMode.useCachedTicks;

    final newScalingFactor = min(
      max(
        scalingFactorOnStart * scale,
        minScalingFactor,
      ),
      maxScalingFactor,
    );

    domainAxis.setViewportSettings(
      newScalingFactor,
      domainAxis.viewportTranslatePx,
      drawAreaWidth: chart.drawAreaBounds.width,
      drawAreaHeight: chart.drawAreaBounds.height,
    );

    chart.redraw(skipAnimation: true, skipLayout: true);

    return true;
  }

  @override
  bool onDragEnd(Point<double> localPosition, double scale, double pixelsPerSec) {
    _isZooming = false;
    final superRes = super.onDragEnd(localPosition, scale, pixelsPerSec);
    _refreshStage(scale);
    return superRes;
  }

  void _refreshStage(double zoomStartRelativeScale) {
    final chart = this.chart as StagedTimeSeriesChart?;

    if (zoomStartRelativeScale == 1.0) return;
    if (chart == null) return;

    final datumAmountInViewport = chart.bounds.datumAmountInViewport;

    final neededStageChange = _needChangeStage(
      zoomStartRelativeScale,
      datumAmountInViewport,
    );

    if (neededStageChange == null) return;

    final stageChange = chart.stage.maybeChangeStage(neededStageChange);

    if (stageChange == null) return;

    final oldViewport = (chart.domainAxis!.scale as DateTimeScale).viewportDomain;

    final oldStart = oldViewport.start.millisecondsSinceEpoch;
    final oldEnd = oldViewport.end.millisecondsSinceEpoch;
    final oldViewportDuration = oldEnd - oldStart;

    final viewportCenterMs = (oldStart + oldEnd) ~/ 2;

    late final double newDataDuration;
    switch (stageChange) {
      case Directions.increase:
        newDataDuration = oldViewportDuration * minScalingFactor;
        break;
      case Directions.decrease:
        newDataDuration = oldViewportDuration * maxScalingFactor;
        break;
    }

    final newStart = (viewportCenterMs - newDataDuration / 2).toInt();
    final newEnd = (viewportCenterMs + newDataDuration / 2).toInt();

    final dataRange = DateTimeRange(
      start: DateTime.fromMillisecondsSinceEpoch(newStart),
      end: DateTime.fromMillisecondsSinceEpoch(newEnd),
    );

    chart.refreshChartData(dataRange);

    chart.domainAxis!.scale!.setViewportSettings(
      _switchNewScalingFactor(stageChange),
      0,
    );

    final viewportIsBoundary = _viewportIsBoundary(
      chart.domainAxis!.viewportScalingFactor,
      chart.domainAxis!.viewportTranslatePx,
    );

    if (viewportIsBoundary) {
      final viewportCenter = DateTime.fromMillisecondsSinceEpoch(viewportCenterMs);
      chart.shiftData(maxDataForChart, viewportCenter);
    }

    chart.redraw(skipAnimation: false, skipLayout: true);
  }

  double _switchNewScalingFactor(Directions stageChange) {
    switch (stageChange) {
      case Directions.increase:
        return minScalingFactor;
      case Directions.decrease:
        return maxScalingFactor;
    }
  }

  ///Allow to change stage only if user zooms in corresponding direction
  Directions? _needChangeStage(
    double startRelativeScale,
    int dataAmountInViewport,
  ) {
    late final Directions? scaleDir;
    if (startRelativeScale > 1.0) {
      scaleDir = Directions.increase;
    } else if (startRelativeScale < 1.0) {
      scaleDir = Directions.decrease;
    } else {
      scaleDir = null;
    }

    late final Directions? scaleChangeZone;
    final dataRelativeScale = chart!.domainAxis!.viewportScalingFactor;
    if (dataRelativeScale > maxScalingFactor - stageChangeTriggeringZone) {
      scaleChangeZone = Directions.increase;
    } else if (dataRelativeScale < minScalingFactor + stageChangeTriggeringZone) {
      scaleChangeZone = Directions.decrease;
    } else {
      scaleChangeZone = null;
    }

    if (scaleChangeZone == scaleDir) return scaleDir;

    return null;
  }

  bool _viewportIsBoundary(
    double viewportScalingFactor,
    double viewportTranslate,
  ) {
    final width = chart!.drawAreaBounds.width;
    final maxTranslate = -1.0 * width * (viewportScalingFactor - 1);
    final newViewportTranslate = min(max(viewportTranslate, maxTranslate), 0.0);

    if (newViewportTranslate == 0.0) return true;
    if (newViewportTranslate == maxTranslate) return true;
    return false;
  }
}
