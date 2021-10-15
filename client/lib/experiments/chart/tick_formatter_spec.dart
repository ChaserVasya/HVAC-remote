// ignore_for_file: implementation_imports

import 'package:charts_common/common.dart';
import 'package:charts_common/src/chart/cartesian/axis/time/time_tick_formatter.dart';
import 'package:charts_common/src/chart/cartesian/axis/time/time_tick_formatter_impl.dart';
import 'package:charts_common/src/chart/cartesian/axis/time/hour_tick_formatter.dart';

///Additional second formatter
class CustomFormatterSpec extends AutoDateTimeTickFormatterSpec {
  @override
  DateTimeTickFormatter createTickFormatter(ChartContext context) {
    TimeTickFormatter;
    return DateTimeTickFormatter.withFormatters(
      <int, TimeTickFormatter>{
        DateTimeTickFormatter.SECOND + 1: TimeTickFormatterImpl(
          dateTimeFactory: context.dateTimeFactory,
          simpleFormat: 'ss',
          transitionFormat: 'hh mm ss',
          transitionField: CalendarField.minute,
        ),
        DateTimeTickFormatter.MINUTE: TimeTickFormatterImpl(
          dateTimeFactory: context.dateTimeFactory,
          simpleFormat: 'mm',
          transitionFormat: 'h mm',
          transitionField: CalendarField.hourOfDay,
        ),
        DateTimeTickFormatter.HOUR: HourTickFormatter(
          dateTimeFactory: context.dateTimeFactory,
          simpleFormat: 'h',
          transitionFormat: 'MMM d ha',
          noonFormat: 'ha',
        ),
        23 * DateTimeTickFormatter.HOUR: TimeTickFormatterImpl(
          dateTimeFactory: context.dateTimeFactory,
          simpleFormat: 'd',
          transitionFormat: 'MMM d',
          transitionField: CalendarField.month,
        ),
        28 * DateTimeTickFormatter.DAY: TimeTickFormatterImpl(
          dateTimeFactory: context.dateTimeFactory,
          simpleFormat: 'MMM',
          transitionFormat: 'MMM yyyy',
          transitionField: CalendarField.year,
        ),
        364 * DateTimeTickFormatter.DAY: TimeTickFormatterImpl(
          dateTimeFactory: context.dateTimeFactory,
          simpleFormat: 'yyyy',
          transitionFormat: 'yyyy',
          transitionField: CalendarField.year,
        ),
      },
    );
  }
}
