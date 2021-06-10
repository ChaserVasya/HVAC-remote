import 'exception_alert.dart';

class UnhandledAlert extends ExceptionAlert {
  const UnhandledAlert([String? details])
      : super(
          titleForUser: 'Необработанная ошибка',
          textForUser: 'Сведения об ошибке будут отправлены на сервер для исправления в следующих версиях.',
          details: details,
        );
}

class ProgrammaticalErrorAlert extends ExceptionAlert {
  const ProgrammaticalErrorAlert()
      : super(
          titleForUser: 'Программная ошибка',
          textForUser: 'Сведения об ошибке будут отправлены на сервер для исправления в следующих версиях.',
        );
}
