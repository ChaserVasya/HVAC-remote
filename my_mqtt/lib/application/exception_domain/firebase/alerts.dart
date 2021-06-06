import 'package:my_mqtt/application/exception_domain/common/exception_alert.dart';

class EmailAlreadyInUseAlert extends ExceptionAlert {
  const EmailAlreadyInUseAlert(String details)
      : super(
          titleForUser: 'E-mail уже использован',
          textForUser: 'Восстановите доступ к аккаунту, привязанному к введённому E-mail, или введите другой E-mail.',
          details: details,
        );
}

class ExpiredActionCodeAlert extends ExceptionAlert {
  const ExpiredActionCodeAlert(String details)
      : super(
          titleForUser: 'Код истёк',
          textForUser: 'Отправьте код повторно.',
          details: details,
        );
}

class InvalidActionCodeAlert extends ExceptionAlert {
  const InvalidActionCodeAlert(String details)
      : super(
          titleForUser: 'Недействительный код',
          textForUser: 'Код неверен или уже использован.',
          details: details,
        );
}

class InvalidEmailAlert extends ExceptionAlert {
  const InvalidEmailAlert(String details)
      : super(
          titleForUser: 'Введённый E-mail невалиден',
          textForUser: 'Проверьте введённый E-mail на наличие некорректных символов',
          details: details,
        );
}

class InvalidVerificationCodeAlert extends ExceptionAlert {
  const InvalidVerificationCodeAlert(String details)
      : super(
          titleForUser: 'Неправильный код подтверждения',
          textForUser: 'Пароль не предоставлен или не соответствует паролю, привязанному к аккаунту.',
          details: details,
        );
}

class OperationNotAllowedAlert extends ExceptionAlert {
  const OperationNotAllowedAlert(String details)
      : super(
          titleForUser: 'Запрещённая операция',
          textForUser: 'Клиент-приложение не согласовано с сервером. Сообщите об ошибке и ожидайте обновления.',
          details: details,
        );
}

class UserDisabledAlert extends ExceptionAlert {
  const UserDisabledAlert(String details)
      : super(
          titleForUser: 'Аккаунт заблокирован',
          textForUser: 'Обратитесь к администратору за комментариями.',
          details: details,
        );
}

class UserNotFoundAlert extends ExceptionAlert {
  const UserNotFoundAlert(String details)
      : super(
          titleForUser: 'Аккаунт не найден',
          textForUser: ''' Не найден аккаунт, привязанный к данным реквизитам.Возможные причины:
-Между действиями, требующими авторизации, произошло удаление пользователя.
-Аккаунт не зарегистрирован.
-Аккаунт не привязан к указанным реквизитам.''',
          details: details,
        );
}

class WeakPasswordAlert extends ExceptionAlert {
  const WeakPasswordAlert(String details)
      : super(
          titleForUser: 'Слабый пароль',
          textForUser: 'Добавьте цифр, букв разного регистра.',
          details: details,
        );
}

class WrongPasswordAlert extends ExceptionAlert {
  const WrongPasswordAlert(String details)
      : super(
          titleForUser: 'Неправильный пароль',
          textForUser: 'Пароль неправильный или не установлен для аккаунта.',
          details: details,
        );
}
