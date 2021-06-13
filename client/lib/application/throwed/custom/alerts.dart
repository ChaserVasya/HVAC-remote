import 'package:hvac_remote_client/application/throwed/common/exception_alert.dart';

class IncorrectrepeatedAlert extends ExceptionAlert {
  const IncorrectrepeatedAlert()
      : super(
          titleForUser: 'Пароли не совпадают',
          textForUser: 'Пароль и повторный пароль не совпадают. Перепроверьте и повторите.',
        );
}

class RoleNotChangedAlert extends ExceptionAlert {
  const RoleNotChangedAlert()
      : super(
          titleForUser: 'Неверный пароль',
          textForUser: 'Роль не изменена. Обратите внимание - пробелы считаются за символ.',
        );
}
