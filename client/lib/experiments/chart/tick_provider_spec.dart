import 'package:charts_common/common.dart';

import 'second_time_stepper.dart';

class CustomTickProviderSpec extends AutoDateTimeTickProviderSpec {
  @override
  AutoAdjustingDateTimeTickProvider createTickProvider(ChartContext context) {
    return includeTime
        ? _createAutoProvider(context.dateTimeFactory)
        : AutoAdjustingDateTimeTickProvider.createWithoutTime(context.dateTimeFactory);
  }

  AutoAdjustingDateTimeTickProvider _createAutoProvider(DateTimeFactory dateTimeFactory) =>
      AutoAdjustingDateTimeTickProvider.createWith([
        AutoAdjustingDateTimeTickProvider.createYearTickProvider(dateTimeFactory),
        AutoAdjustingDateTimeTickProvider.createMonthTickProvider(dateTimeFactory),
        AutoAdjustingDateTimeTickProvider.createDayTickProvider(dateTimeFactory),
        AutoAdjustingDateTimeTickProvider.createHourTickProvider(dateTimeFactory),
        AutoAdjustingDateTimeTickProvider.createMinuteTickProvider(dateTimeFactory),
        TimeRangeTickProviderImpl(SecondTimeStepper(dateTimeFactory)),
      ]);
}
