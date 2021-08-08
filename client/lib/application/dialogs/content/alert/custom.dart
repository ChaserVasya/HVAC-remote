import 'package:hvac_remote_client/application/dialogs/content/interfaces/alert.dart';

class EmailAlreadyInUseAlert implements AlertDialogContent {
  const EmailAlreadyInUseAlert();
  @override
  final String textForUser =
      'Восстановите доступ к аккаунту, привязанному к введённому E-mail, или введите другой E-mail.';

  @override
  final String titleForUser = 'E-mail уже использован';

  @override
  final ActionBuilder? actionsBuilder = null;

  @override
  final String? details = null;
}

class ExpiredActionCodeAlert implements AlertDialogContent {
  const ExpiredActionCodeAlert();
  @override
  final String textForUser = 'Отправьте код повторно.';

  @override
  final String titleForUser = 'Код истёк';

  @override
  final ActionBuilder? actionsBuilder = null;

  @override
  final String? details = null;
}

class InvalidActionCodeAlert implements AlertDialogContent {
  const InvalidActionCodeAlert();
  @override
  final String textForUser = 'Код неверен или уже использован.';

  @override
  final String titleForUser = 'Недействительный код';

  @override
  final ActionBuilder? actionsBuilder = null;

  @override
  final String? details = null;
}

class InvalidEmailAlert implements AlertDialogContent {
  const InvalidEmailAlert();
  @override
  final String textForUser = 'Проверьте введённый E-mail на наличие некорректных символов';

  @override
  final String titleForUser = 'Введённый E-mail невалиден';

  @override
  final ActionBuilder? actionsBuilder = null;

  @override
  final String? details = null;
}

class InvalidVerificationCodeAlert implements AlertDialogContent {
  const InvalidVerificationCodeAlert();

  @override
  final String textForUser = 'Пароль не предоставлен или не соответствует паролю, привязанному к аккаунту.';

  @override
  final String titleForUser = 'Неправильный код подтверждения';

  @override
  final ActionBuilder? actionsBuilder = null;

  @override
  final String? details = null;
}

class OperationNotAllowedAlert implements AlertDialogContent {
  const OperationNotAllowedAlert();
  @override
  final String textForUser = 'Клиент-приложение не согласовано с сервером. Сообщите об ошибке и ожидайте обновления.';

  @override
  final String titleForUser = 'Запрещённая операция';

  @override
  final ActionBuilder? actionsBuilder = null;

  @override
  final String? details = null;
}

class UserDisabledAlert implements AlertDialogContent {
  const UserDisabledAlert();
  @override
  final String textForUser = 'Обратитесь к администратору за комментариями.';

  @override
  final String titleForUser = 'Аккаунт заблокирован';

  @override
  final ActionBuilder? actionsBuilder = null;

  @override
  final String? details = null;
}

class UserNotFoundAlert implements AlertDialogContent {
  const UserNotFoundAlert();
  @override
  final String textForUser = '''Не найден аккаунт, привязанный к данным реквизитам. Возможные причины:

-Между действиями, требующими авторизации, произошло удаление пользователя.

-Аккаунт не зарегистрирован.

-Аккаунт не привязан к указанным реквизитам.''';

  @override
  final String titleForUser = 'Аккаунт не найден';

  @override
  final ActionBuilder? actionsBuilder = null;

  @override
  final String? details = null;
}

class WeakPasswordAlert implements AlertDialogContent {
  const WeakPasswordAlert();
  @override
  final String textForUser = 'Добавьте цифр, букв разного регистра.';

  @override
  final String titleForUser = 'Слабый пароль';

  @override
  final ActionBuilder? actionsBuilder = null;

  @override
  final String? details = null;
}

class WrongPasswordAlert implements AlertDialogContent {
  const WrongPasswordAlert();
  @override
  final String textForUser = 'Пароль неправильный или регистрация проводилась методами не требущими пароля.';

  @override
  final String titleForUser = 'Неправильный пароль';

  @override
  final ActionBuilder? actionsBuilder = null;

  @override
  final String? details = null;
}

class TooManyRequestsAlert implements AlertDialogContent {
  const TooManyRequestsAlert();
  @override
  final String textForUser =
      'Обнаружено подозрительное поведение. В течении какого-то времени запросы будут заблокированы. Попробуйте позже';

  @override
  final String titleForUser = 'Подозрительное поведение';

  @override
  final ActionBuilder? actionsBuilder = null;

  @override
  final String? details = null;
}

class RequiresRecentLoginAlert implements AlertDialogContent {
  const RequiresRecentLoginAlert();
  @override
  final String textForUser =
      'Запрошена операция с чувствительными данными, но вход в аккаунт был произведён слишком давно. С целью предотвращения несанкционированного доступа необходимо перелогиниться: выйдите из аккаунта и снова войдите.';

  @override
  final String titleForUser = 'Требуется перелогиниться';

  @override
  final ActionBuilder? actionsBuilder = null;

  @override
  final String? details = null;
}

class NetworkRequestFailedAlert implements AlertDialogContent {
  const NetworkRequestFailedAlert();
  @override
  final String textForUser = 'Проверьте соединение с интернетом.';

  @override
  final String titleForUser = 'Запрос не доставлен';

  @override
  final ActionBuilder? actionsBuilder = null;

  @override
  final String? details = null;
}
