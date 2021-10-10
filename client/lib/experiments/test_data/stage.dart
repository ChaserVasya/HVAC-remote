import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hvac_remote_client/experiments/chart/time_series_data.dart';

const List<Stage> stages = [
  Stage._(
    valueStep: TimeSteps.year,
    fileStep: TimeSteps.year,
  ),
  Stage._(
    valueStep: TimeSteps.month,
    fileStep: TimeSteps.year,
  ),
  Stage._(
    valueStep: TimeSteps.day,
    fileStep: TimeSteps.month,
  ),
  Stage._(
    valueStep: TimeSteps.hour,
    fileStep: TimeSteps.month,
  ),
  Stage._(
    valueStep: TimeSteps.minute,
    fileStep: TimeSteps.day,
  ),
  Stage._(
    valueStep: TimeSteps.second,
    fileStep: TimeSteps.day,
  ),
];

class Stage {
  static final existingDataRange = DateTimeRange(
    start: DateTime(2021),
    end: DateTime(2029).subtract(const Duration(microseconds: 1)),
  );

  final TimeSteps valueStep;
  final TimeSteps fileStep;

  const Stage._({
    required this.valueStep,
    required this.fileStep,
  });

  int get filesAmount => _coveredSteps(existingDataRange, fileStep);

  DateTime addToValueTimeStamp(DateTime timeStamp, int steps) {
    return _increaseDateTimeOn(steps, timeStamp, valueStep);
  }

  List<TimeSeries> deoptimize(List<int> values, DateTime firstValueTimeStamp) {
    return List.generate(
      values.length,
      (i) => TimeSeries(
        value: values[i],
        usSinceEpoch: addToValueTimeStamp(firstValueTimeStamp, i).microsecondsSinceEpoch,
      ),
    );
  }

  DateTime floorValueTimeStamp(DateTime timeStamp) {
    return _floorToStep(timeStamp, valueStep);
  }

  List<File>? getFilesCoveredRange(List<File> files, DateTimeRange valueRange) {
    final retrievableRange = valueRange & existingDataRange;
    if (retrievableRange == null) return null;

    return _pullSublistWithRange(
      files,
      existingDataRange.start,
      retrievableRange,
      fileStep,
    );
  }

  DateTime getFileTimeStamp(fileIndex) {
    return _increaseDateTimeOn(fileIndex, existingDataRange.start, fileStep);
  }

  DateTimeRange? getPullableRange(
    List<int> source,
    DateTime sourceStartTimeStamp,
    DateTimeRange requestedRange,
  ) {
    final sourceRange = DateTimeRange(
      start: sourceStartTimeStamp,
      end: addToValueTimeStamp(sourceStartTimeStamp, source.length)
          .subtract(const Duration(microseconds: 1)),
    );

    final pullableRange = sourceRange & requestedRange;

    if (pullableRange == null) return null;

    return pullableRange;
  }

  List<int>? pullValuesWithRange(
    List<int> source,
    DateTime sourceStartTimeStamp,
    DateTimeRange requestedRange,
  ) {
    return _pullSublistWithRange(
      source,
      sourceStartTimeStamp,
      requestedRange,
      valueStep,
    );
  }

  int getValuesInFile(int fileIndex) {
    final fileCoveredRange = DateTimeRange(
      start: _increaseDateTimeOn(fileIndex, existingDataRange.start, fileStep),
      end: _increaseDateTimeOn(fileIndex + 1, existingDataRange.start, fileStep)
          .subtract(const Duration(microseconds: 1)),
    );

    return _coveredSteps(fileCoveredRange, valueStep);
  }

  int _coveredSteps(DateTimeRange range, TimeSteps step) {
    switch (step) {
      case TimeSteps.second:
        return range.duration.inSeconds + 1;
      case TimeSteps.minute:
        return range.duration.inMinutes + 1;
      case TimeSteps.hour:
        return range.duration.inHours + 1;
      case TimeSteps.day:
        return range.duration.inDays + 1;
      case TimeSteps.month:
        final yearDiff = range.end.year - range.start.year;
        return yearDiff * DateTime.monthsPerYear + range.end.month - range.start.month + 1;
      case TimeSteps.year:
        return range.end.year - range.start.year + 1;
    }
  }

  DateTime _floorToStep(DateTime dateTime, TimeSteps step) {
    int y = dateTime.year;
    int m = dateTime.month;
    int d = dateTime.day;
    int h = dateTime.hour;
    int min = dateTime.minute;
    int sec = dateTime.second;
    int ms = dateTime.millisecond;
    int us = dateTime.microsecond;

    switch (step) {
      case TimeSteps.year:
        m = 1;
        continue m;
      m:
      case TimeSteps.month:
        d = 1;
        continue d;
      d:
      case TimeSteps.day:
        h = 0;
        continue h;
      h:
      case TimeSteps.hour:
        min = 0;
        continue min;
      min:
      case TimeSteps.minute:
        sec = 0;
        continue sec;
      sec:
      case TimeSteps.second:
        us = 0;
        ms = 0;
        break;
    }
    final date = DateTime(y, m, d, h, min, sec, ms, us);
    return date;
  }

  DateTime _increaseDateTimeOn(int steps, DateTime dateTime, TimeSteps step) {
    int y = dateTime.year;
    int m = dateTime.month;
    int d = dateTime.day;
    int h = dateTime.hour;
    int min = dateTime.minute;
    int sec = dateTime.second;
    int ms = dateTime.millisecond;
    int us = dateTime.microsecond;

    switch (step) {
      case TimeSteps.second:
        sec += steps;
        break;
      case TimeSteps.minute:
        min += steps;
        break;
      case TimeSteps.hour:
        h += steps;
        break;
      case TimeSteps.day:
        d += steps;
        break;
      case TimeSteps.month:
        m += steps;
        break;
      case TimeSteps.year:
        y += steps;
        break;
    }
    return DateTime(y, m, d, h, min, sec, ms, us);
  }

  List<T> _pullSublistWithRange<T>(
    List<T> source,
    DateTime sourceStartTimeStamp,
    DateTimeRange requestedRange,
    TimeSteps elementStep,
  ) {
    final startIndex = -1 +
        _coveredSteps(
          DateTimeRange(
            start: sourceStartTimeStamp,
            end: requestedRange.start,
          ),
          elementStep,
        );

    final endIndex = -1 +
        _coveredSteps(
          DateTimeRange(
            start: sourceStartTimeStamp,
            end: requestedRange.end,
          ),
          elementStep,
        );

    return source.getRange(startIndex, endIndex + 1).toList(growable: false);
  }
}

enum TimeSteps {
  second,
  minute,
  hour,
  day,
  month,
  year,
}

extension DateTimeRangeAnd on DateTimeRange {
  DateTimeRange? operator &(DateTimeRange other) {
    final start = (this.start.isAfter(other.start)) ? this.start : other.start;
    final end = (this.end.isBefore(other.end)) ? this.end : other.end;

    if (start.isAfter(end)) return null;

    return DateTimeRange(start: start, end: end);
  }
}

extension DateTimeWindowsSafeFormat on DateTime {
  String toWindowsSafeFormat() {
    const fractional = '\\.\\d+';
    const sign = '\\W';
    return toIso8601String().replaceAll(RegExp('$fractional|$sign'), '');
  }
}

extension TimeStepsValue on TimeSteps {
  String get value => toString().split('.').last;
}
