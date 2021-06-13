import 'exception_alert.dart';

/*
For unknown firebase error codes. Firebase hasn`t complete code docs. I had to
find out them by myself. I can`t be sure that I has caught all codes, so, 
I  created this exception alert for unhandled case.
*/
class UnhandledAlert extends ExceptionAlert {
  const UnhandledAlert([String? details])
      : super(
          titleForUser: 'Необработанная ошибка',
          textForUser: 'Сведения об ошибке будут отправлены на сервер для исправления в следующих версиях.',
          details: details,
        );
}

/*
All dev errors, which can be made: syntax, logic, null check, dirty widget state 
and ets. The meaning of this alert - hot fix it
*/
class DevErrorAlert extends ExceptionAlert {
  const DevErrorAlert()
      : super(
          titleForUser: 'Программная ошибка',
          textForUser: 'Сведения об ошибке будут отправлены на сервер для исправления в следующих версиях.',
        );
}

class EmptyStringAlert extends ExceptionAlert {
  const EmptyStringAlert([String? details])
      : super(
          titleForUser: 'Пустая строка',
          textForUser: 'Пустая строка недопустима.',
          details: details,
        );
}
