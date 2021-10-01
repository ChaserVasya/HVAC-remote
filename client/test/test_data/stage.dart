const List<Stage> stages = [
  Stage(
    valueStep: TimeSteps.year,
    fileStep: TimeSteps.year,
  ),
  Stage(
    valueStep: TimeSteps.month,
    fileStep: TimeSteps.year,
  ),
  Stage(
    valueStep: TimeSteps.day,
    fileStep: TimeSteps.month,
  ),
  Stage(
    valueStep: TimeSteps.hour,
    fileStep: TimeSteps.month,
  ),
  Stage(
    valueStep: TimeSteps.minute,
    fileStep: TimeSteps.day,
  ),
  Stage(
    valueStep: TimeSteps.second,
    fileStep: TimeSteps.day,
  ),
];

class Stage {
  static const _coveredRange = Duration(days: DateTimeConsts.daysPerYear * 10);
  static final refPoint = DateTime(2021, 9, 15);

  final TimeSteps valueStep;
  final TimeSteps fileStep;

  const Stage({
    required this.valueStep,
    required this.fileStep,
  });

  int get filesAmount {
    return _coveredRange.inSeconds ~/ fileStep.toDuration().inSeconds;
  }

  int get valuesPerFile {
    final fileDuration = fileStep.toDuration();
    final valuesDuration = valueStep.toDuration();
    return fileDuration.inSeconds ~/ valuesDuration.inSeconds;
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

extension DateTimeConsts on DateTime {
  static const daysPerMonth = 30; //! not variable

  static const daysPerYear = DateTimeConsts.daysPerMonth * DateTime.monthsPerYear;
  static const secondsPerYear = Duration.secondsPerDay * DateTimeConsts.daysPerYear;
  static const minutesPerYear = Duration.minutesPerDay * DateTimeConsts.daysPerYear;
  static const hoursPerYear = Duration.hoursPerDay * DateTimeConsts.daysPerYear;

  String get date => toString().split(' ').first;
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

extension TimeStepsDurations on TimeSteps {
  Duration toDuration() {
    switch (index) {
      case 0:
        return const Duration(seconds: 1);
      case 1:
        return const Duration(minutes: 1);
      case 2:
        return const Duration(hours: 1);
      case 3:
        return const Duration(days: 1);
      case 4:
        return const Duration(days: DateTimeConsts.daysPerMonth);
      case 5:
        return const Duration(days: DateTimeConsts.daysPerYear);
      default:
        throw Exception();
    }
  }
}
