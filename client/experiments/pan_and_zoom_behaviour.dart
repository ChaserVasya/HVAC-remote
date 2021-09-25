import 'dart:math';

import 'package:charts_common/common.dart' as common;
import 'package:charts_flutter/flutter.dart' as flutter;
import 'package:flutter/material.dart';
import 'package:meta/meta.dart' show immutable;

import 'package:charts_flutter/src/behaviors/zoom/pan_behavior.dart' as flutter;
import 'package:charts_flutter/src/behaviors/zoom/pan_and_zoom_behavior.dart' as flutter;

import 'common_staged_chart.dart';
import 'package:charts_common/src/chart/cartesian/axis/time/date_time_scale.dart';

@immutable
class FlutterPanAndZoomBehavior<D> extends flutter.PanAndZoomBehavior<D> {
  FlutterPanAndZoomBehavior({required this.commonBehavior});

  final CommonPanAndZoomBehavior<D> commonBehavior;

  @override
  common.PanAndZoomBehavior<D> createCommonBehavior() => commonBehavior;
}

//TODO underscale text is rare. Fill underscale by text.
//TODO refactor
//TODO docs
class CommonPanAndZoomBehavior<D> extends common.PanBehavior<D>
    with flutter.FlutterPanBehaviorMixin
    implements common.PanAndZoomBehavior<D> {
  @override
  String get role => 'PanAndZoom';

  /// Flag which is enabled to indicate that the user is "zooming" the _chart.
  bool _isZooming = false;

  @override
  bool get isZooming => _isZooming;

  final Thinner _thinner = Thinner();

  late double _scalingFactorOnStart;

  late final _chart = chart as StagedTimeSeriesChart;

  @override
  bool onDragStart(Point<double> localPosition) {
    super.onDragStart(localPosition);

    _scalingFactorOnStart = _chart.domainAxis!.viewportScalingFactor;
    _isZooming = true;

    return true;
  }

  @override
  bool onDragUpdate(Point<double> localPosition, double scale) {
    if (scale == 1.0) {
      print("p");
      _isZooming = false;
      return super.onDragUpdate(localPosition, scale);
    } else {
      _isZooming = true;
    }

    cancelPanning();

    _thinner.next();
    if (!_thinner.pass) return true;

    if (!_isZooming || lastPosition == null) return false;
    print("z");

    final domainAxis = _chart.domainAxis;

    if (domainAxis == null) return false;

    // domainAxisTickProvider.mode = common.PanningTickProviderMode.useCachedTicks;

    final newScalingFactor = min(
      max(
        _scalingFactorOnStart * scale,
        _chart.stage.params.minScalingFactor,
      ),
      _chart.stage.params.maxScalingFactor,
    );

    domainAxis.setViewportSettings(
      newScalingFactor,
      domainAxis.viewportTranslatePx,
      drawAreaWidth: _chart.drawAreaBounds.width,
      drawAreaHeight: _chart.drawAreaBounds.height,
    );
    _chart.redraw(skipAnimation: true, skipLayout: true);
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
    if (zoomStartRelativeScale == 1.0) return;

    final datumAmountInViewport = _chart.bounds.datumAmountInViewport;

    final neededStageChange = _needChangeStage(
      zoomStartRelativeScale,
      datumAmountInViewport,
    );

    if (neededStageChange == null) return;

    final stageChange = _chart.stage.maybeChangeStage(neededStageChange);

    if (stageChange == null) return;

    final oldViewport = (_chart.domainAxis!.scale as DateTimeScale).viewportDomain;

    final oldStart = oldViewport.start.millisecondsSinceEpoch;
    final oldEnd = oldViewport.end.millisecondsSinceEpoch;
    final oldViewportDuration = oldEnd - oldStart;

    final viewportCenter = (oldStart + oldEnd) ~/ 2;

    late final double newDataDuration;
    switch (stageChange) {
      case Directions.increase:
        newDataDuration = oldViewportDuration * _chart.stage.params.minScalingFactor;

        break;
      case Directions.decrease:
        newDataDuration = oldViewportDuration * _chart.stage.params.maxScalingFactor;
        break;
    }

    final newStart = (viewportCenter - newDataDuration / 2).toInt();
    final newEnd = (viewportCenter + newDataDuration / 2).toInt();

    final dataRange = DateTimeRange(
      start: DateTime.fromMillisecondsSinceEpoch(newStart),
      end: DateTime.fromMillisecondsSinceEpoch(newEnd),
    );

    _chart.refreshChartData(dataRange);

    _chart.domainAxis!.scale!.setViewportSettings(_switchNewScalingFactor(stageChange), 0);

    final viewportIsBoundary = _viewportIsBoundary(
      _chart.domainAxis!.viewportScalingFactor,
      _chart.domainAxis!.viewportTranslatePx,
    );

    if (viewportIsBoundary) {
      _chart.shiftData(
        _chart.stage.params.maxDataForChart,
        DateTime.fromMillisecondsSinceEpoch(viewportCenter),
      );
    }

    _chart.redraw(skipAnimation: true, skipLayout: true);
  }

  double _switchNewScalingFactor(Directions stageChange) {
    switch (stageChange) {
      case Directions.increase:
        return _chart.stage.params.minScalingFactor;
      case Directions.decrease:
        return _chart.stage.params.maxScalingFactor;
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
    final dataRelativeScale = _chart.domainAxis!.viewportScalingFactor;
    final params = (_chart as StagedTimeSeriesChart).stage.params;
    if (dataRelativeScale > params.maxScalingFactor - params.stageChangeTriggeringZone) {
      scaleChangeZone = Directions.increase;
    } else if (dataRelativeScale < params.minScalingFactor + params.stageChangeTriggeringZone) {
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
    final width = _chart.drawAreaBounds.width;
    final maxTranslate = -1.0 * width * (viewportScalingFactor - 1);
    final newViewportTranslate = min(max(viewportTranslate, maxTranslate), 0.0);

    if (newViewportTranslate == 0.0) return true;
    if (newViewportTranslate == maxTranslate) return true;
    return false;
  }
}

//TODO Can I reduce checks frequency in other way?

///Zoom is checked so often that the _chart freezes. This class shows
///which checks should be allowed.
class Thinner {
  static const int _loopStart = 1;
  static const int _loopEnd = 20;
  static const int _passing = _loopEnd;

  int _current = _loopStart;

  void next() {
    _current++;
    if (_current > _loopEnd) _current = _loopStart;
  }

  bool get pass => _current == _passing;
}
