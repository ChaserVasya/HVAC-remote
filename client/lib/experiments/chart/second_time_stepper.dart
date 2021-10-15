import 'package:charts_common/common.dart';

class SecondTimeStepper extends BaseTimeStepper {
  static const _defaultIncrements = [1, 5, 10, 15, 20, 30];

  SecondTimeStepper(DateTimeFactory dateTimeFactory) : super(dateTimeFactory);

  @override
  List<int> get allowedTickIncrements => _defaultIncrements;

  @override
  int get typicalStepSizeMs => Duration.millisecondsPerSecond;

  @override
  DateTime getNextStepTime(DateTime time, int tickIncrement) {
    return time.change(second: tickIncrement * (time.second ~/ tickIncrement + 1));
  }

  @override
  DateTime getStepTimeBeforeInclusive(DateTime time, int tickIncrement) {
    return dateTimeFactory.createDateTimeFromMilliSecondsSinceEpoch(
      time
          .change(
            second: time.second - (time.second % tickIncrement),
          )
          .millisecondsSinceEpoch,
    );
  }
}

extension on DateTime {
  DateTime change({
    int? year,
    int? month,
    int? day,
    int? hour,
    int? minute,
    int? second,
    int? millisecond,
    int? microsecond,
  }) =>
      DateTime(
        year ?? this.year,
        month ?? this.month,
        day ?? this.day,
        hour ?? this.hour,
        minute ?? this.minute,
        second ?? this.second,
        millisecond ?? this.millisecond,
        microsecond ?? this.microsecond,
      );
}
