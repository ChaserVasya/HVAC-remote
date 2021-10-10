import 'dart:math';

import 'package:charts_common/common.dart' as common;
import 'package:charts_flutter/flutter.dart' as flutter;
import 'package:flutter/material.dart';
import 'package:meta/meta.dart' show immutable;

import 'package:charts_flutter/src/behaviors/zoom/pan_behavior.dart' as flutter;
import 'package:charts_flutter/src/behaviors/zoom/pan_and_zoom_behavior.dart' as flutter;
import 'package:path/path.dart';

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

//TODO fix: ticks throw exception if only one tick in viewport
//TODO underscale text is rare. Fill underscale by text.
//TODO refactor
//TODO docs
class CommonPanAndZoomBehavior<D> extends common.PanBehavior<D>
    with flutter.FlutterPanBehaviorMixin
    implements common.PanAndZoomBehavior<D> {
  CommonPanAndZoomBehavior({required this.refreshDataCallaback});

  final void Function(List<TimeSeries>) refreshDataCallaback;

  @override
  String get role => 'PanAndZoom';

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
      _isZooming = false;
      try {
        return super.onDragUpdate(localPosition, scale);
      } catch (e) {
        //TODO fix: no ticket error (Bad state: No element)
        if (e is StateError) return true; //! no ticket error
        rethrow;
      }
    } else {
      _isZooming = true;
    }

    domainAxisTickProvider.mode = common.PanningTickProviderMode.passThrough;

    cancelPanning();

    _thinner.next();
    if (!_thinner.pass) return true;

    if (!_isZooming || lastPosition == null) return false;

    final domainAxis = _chart.domainAxis;

    if (domainAxis == null) return false;

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
      // drawAreaWidth: _chart.drawAreaBounds.width,
      // drawAreaHeight: _chart.drawAreaBounds.height,
    );
    _chart.redraw(skipAnimation: false, skipLayout: true);
    return true;
  }

  @override
  bool onDragEnd(Point<double> localPosition, double scale, double pixelsPerSec) {
    _isZooming = false;
    final superRes = super.onDragEnd(localPosition, scale, pixelsPerSec);
    if (scale == 1.0) {
      _maybeShiftData();
    } else {
      _maybeChangeStage(scale);
    }
    return superRes;
  }

  Future<void> _maybeChangeStage(double zoomStartRelativeScale) async {
    var stageChangeDir = _checkStageChangingNeed(zoomStartRelativeScale);
    stageChangeDir = _chart.stage.maybeChangeStage(stageChangeDir);
    if (stageChangeDir == null) return;

    //main target - have the same viewportRange in new stage to prevent viewport leap

    final oldViewport = (_chart.domainAxis!.scale as DateTimeScale).viewportDomain.toRange();

    late final Duration newChartDuration;
    switch (stageChangeDir) {
      case Directions.increase:
        newChartDuration = oldViewport.duration * _chart.stage.params.minScalingFactor;
        break;
      case Directions.decrease:
        newChartDuration = oldViewport.duration * _chart.stage.params.maxScalingFactor;
        break;
    }

    final center = oldViewport.start.add(oldViewport.duration ~/ 2);
    final newDataRange = DateTimeRange(
      start: center.subtract(newChartDuration ~/ 2),
      end: center.add(newChartDuration ~/ 2),
    );

    final newData = await _chart.refreshChartData(newDataRange);

    refreshDataCallaback(newData);
    _chart.domainAxis!.setViewportSettings(
      _switchNewScalingFactor(stageChangeDir),
      _chart.domainAxis!.viewportTranslatePx,
    );

    print('stage ${_chart.stage.current} is set');
  }

  double _switchNewScalingFactor(Directions stageChangeDir) {
    switch (stageChangeDir) {
      case Directions.increase:
        return _chart.stage.params.minScalingFactor;
      case Directions.decrease:
        return _chart.stage.params.maxScalingFactor;
    }
  }

  ///Allow to change stage only if user zooms in corresponding direction
  Directions? _checkStageChangingNeed(double startRelativeScale) {
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
    final params = _chart.stage.params;
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

  Future<void> _maybeShiftData() async {
    final scalingFactor = _chart.domainAxis!.viewportScalingFactor;
    final translate = _chart.domainAxis!.viewportTranslatePx;
    final width = _chart.drawAreaBounds.width;

    final isOnTheRightEdge = translate.roundTo(3) == (width * (1 - scalingFactor)).roundTo(3);
    final isOnTheLeftEdge = translate.roundTo(3) == 0;

    if (!(isOnTheRightEdge || isOnTheLeftEdge) || scalingFactor <= 1) return;

    const shiftFactor = 0.2;

    final oldData = _chart.currentSeriesList.single.data as List<TimeSeries>;
    final oldChartDataRange = DateTimeRange(
      start: oldData.first.dateTime,
      end: oldData.last.dateTime,
    );
    final shift = oldChartDataRange.duration * shiftFactor * (isOnTheLeftEdge ? -1 : 1);
    final newChartDataRange = DateTimeRange(
      start: oldChartDataRange.start.add(shift),
      end: oldChartDataRange.end.add(shift),
    );
    final newData = await _chart.refreshChartData(newChartDataRange);

    late double newTranslate;
    final dataWidth = width * scalingFactor / oldData.length;
    if (isOnTheLeftEdge) {
      final actualDataShift = newData.indexOf(oldData.first);
      newTranslate = translate - actualDataShift * dataWidth;
    } else if (isOnTheRightEdge) {
      final actualDataShift = newData.length - newData.indexOf(oldData.last) - 1;
      newTranslate = translate + actualDataShift * dataWidth;
    }

    refreshDataCallaback(newData);
    _chart.domainAxis!.setViewportSettings(scalingFactor, newTranslate);
    stopFlingAnimation();
  }
}

//TODO Can I reduce checks frequency in other way?

///Zoom is checked so often that the _chart freezes. This class shows
///which checks should be allowed.
class Thinner {
  static const int _passing = 20;

  static const int _loopStart = 1;
  static const int _loopEnd = _passing;

  int _current = _loopStart;

  void next() {
    _current++;
    if (_current > _loopEnd) _current = _loopStart;
  }

  bool get pass => _current == _passing;
}

extension on common.DateTimeExtents {
  DateTimeRange toRange() => DateTimeRange(start: start, end: end);
}

extension on double {
  double roundTo(int decimalPlaces) => double.parse(toStringAsFixed(decimalPlaces));
}
