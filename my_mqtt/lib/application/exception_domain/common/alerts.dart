import 'package:my_mqtt/application/exception_domain/common/exception_alert.dart';

class UnhandledAlert extends ExceptionAlert {
  const UnhandledAlert([String? details])
      : super(
          titleForUser: 'Необработанная ошибка',
          textForUser:
              'Сведения об ошибке будут отправлены на сервер для исправления в следующих версиях. Имеющиеся сведения об ошибке отображены в деталях.',
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
