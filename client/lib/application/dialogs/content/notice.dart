import 'package:hvac_remote_client/application/dialogs/content/interfaces/notice.dart';

class SuccessfulAccountCreateNotice implements NoticeDialogContent {
  const SuccessfulAccountCreateNotice();

  @override
  final String message =
      'Аккаунт создан. На указанную почту отправлено письмо. Перейдите по ссылке в письме, чтобы подтвердить почту.';
}

class NewRoleNotice implements NoticeDialogContent {
  const NewRoleNotice();

  @override
  final String message = 'Роль успешно сменена!';
}

class WrongRolePasswordNotice implements NoticeDialogContent {
  const WrongRolePasswordNotice();

  @override
  final String message = 'Неправильный пароль. Роль не изменена.';
}

class ResetEmailSendedNotice implements NoticeDialogContent {
  const ResetEmailSendedNotice();

  @override
  final String message = 'На почту отправлено письмо. Перейдите по ссылке в письме и введите новый пароль';
}

class DeleteAccountNotice implements NoticeDialogContent {
  const DeleteAccountNotice();

  @override
  final String message = 'Вы действительно хотите удалить аккаунт?';
}

class SendEmailAgainNotice implements NoticeDialogContent {
  const SendEmailAgainNotice();

  @override
  final String message = 'Указанная почта не подтверждена. Отправить письмо ещё раз?';
}
