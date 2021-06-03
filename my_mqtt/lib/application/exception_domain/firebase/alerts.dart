import 'package:firebase_core/firebase_core.dart';
import 'package:my_mqtt/application/exception_domain/common_alerts.dart';
import 'package:my_mqtt/application/exception_domain/exception_alert.dart';

/*
exception-codes have been taken from firebase_auth.dart. Not of all are needed. _Unneeded exception-codes listed for the record. 
!exception-codes can out of date.
codes:
  accountExistsWithDifferentCredential, //!unused
  customTokenMismatch, //!unused
  emailAlreadyInUse,
  expiredActionCode,
  invalidActionCode,
  invalidEmail,
  invalidCredential, //!unused
  invalidCustomToken, //!unused
  invalidVerificationCode, //!unused
  invalidVerificationId, //!unused
  operationNotAllowed,
  userDisabled,
  userNotFound,
  weakPassword,
  wrongPassword,
*/

ExceptionAlert switchFirebaseExceptionAlert(FirebaseException e) {
  String? message = e.message;
  final details = (message != null) ? (e.code + message) : e.code;

  switch (e.code) {
    case 'email-already-in-use':
      return _EmailAlreadyInUseAlert(details);
    case 'expired-action-code':
      return _ExpiredActionCodeAlert(details);
    case 'invalid-action-code':
      return _InvalidActionCodeAlert(details);
    case 'invalid-email':
      return _InvalidEmailAlert(details);
    case 'invalid-verification-code':
      return _InvalidVerificationCodeAlert(details);
    case 'operation-not-allowed':
      return _OperationNotAllowedAlert(details);
    case 'user-disabled':
      return _UserDisabledAlert(details);
    case 'user-not-found':
      return _UserNotFoundAlert(details);
    case 'weak-password':
      return _WeakPasswordAlert(details);
    case 'wrong-password':
      return _WrongPasswordAlert(details);
    default:
      return UnhandledAlert(details);
  }
}

class _EmailAlreadyInUseAlert extends ExceptionAlert {
  const _EmailAlreadyInUseAlert(String details)
      : super(
          titleForUser: 'E-mail уже использован',
          textForUser: 'Восстановите доступ к аккаунту, привязанному к введённому E-mail, или введите другой E-mail.',
          details: details,
        );
}

class _ExpiredActionCodeAlert extends ExceptionAlert {
  const _ExpiredActionCodeAlert(String details)
      : super(
          titleForUser: 'Код истёк',
          textForUser: 'Отправьте код повторно.',
          details: details,
        );
}

class _InvalidActionCodeAlert extends ExceptionAlert {
  const _InvalidActionCodeAlert(String details)
      : super(
          titleForUser: 'Недействительный код',
          textForUser: 'Код неверен или уже использован.',
          details: details,
        );
}

class _InvalidEmailAlert extends ExceptionAlert {
  const _InvalidEmailAlert(String details)
      : super(
          titleForUser: 'Введённый E-mail невалиден',
          textForUser: 'Проверьте введённый E-mail на наличие некорректных символов',
          details: details,
        );
}

class _InvalidVerificationCodeAlert extends ExceptionAlert {
  const _InvalidVerificationCodeAlert(String details)
      : super(
          titleForUser: 'Неправильный код подтверждения',
          textForUser: 'Пароль не предоставлен или не соответствует паролю, привязанному к аккаунту.',
          details: details,
        );
}

class _OperationNotAllowedAlert extends ExceptionAlert {
  const _OperationNotAllowedAlert(String details)
      : super(
          titleForUser: 'Запрещённая операция',
          textForUser: 'Клиент-приложение не согласовано с сервером. Сообщите об ошибке и ожидайте обновления.',
          details: details,
        );
}

class _UserDisabledAlert extends ExceptionAlert {
  const _UserDisabledAlert(String details)
      : super(
          titleForUser: 'Аккаунт заблокирован',
          textForUser: 'Обратитесь к администратору за комментариями.',
          details: details,
        );
}

class _UserNotFoundAlert extends ExceptionAlert {
  const _UserNotFoundAlert(String details)
      : super(
          titleForUser: 'Аккаунт не найден',
          textForUser: ''' Не найден аккаунт, привязанный к данным реквизитам.Возможные причины:
-Между действиями, требующими авторизации, произошло удаление пользователя.
-Аккаунт не зарегистрирован.
-Аккаунт не привязан к указанным реквизитам.''',
          details: details,
        );
}

class _WeakPasswordAlert extends ExceptionAlert {
  const _WeakPasswordAlert(String details)
      : super(
          titleForUser: 'Слабый пароль',
          textForUser: 'Добавьте цифр, букв разного регистра.',
          details: details,
        );
}

class _WrongPasswordAlert extends ExceptionAlert {
  const _WrongPasswordAlert(String details)
      : super(
          titleForUser: 'Неправильный пароль',
          textForUser: 'Пароль не предоставлен или не соответствует паролю, привязанному к аккаунту.',
          details: details,
        );
}
