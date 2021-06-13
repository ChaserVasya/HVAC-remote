import 'notice.dart';

class SuccessfulAccountCreateNotice extends Notice {
  const SuccessfulAccountCreateNotice()
      : super(
          'Аккаунт создан. На указанную почту отправлено письмо. Перейдите по ссылке в письме, чтобы подтвердить почту.',
        );
}

class NewRoleNotice extends Notice {
  NewRoleNotice() : super('Роль успешно сменена!');
}

class WrongRolePasswordNotice extends Notice {
  const WrongRolePasswordNotice() : super('Неправильный пароль. Роль не изменена.');
}

class ResetEmailSendedNotice extends Notice {
  const ResetEmailSendedNotice()
      : super(
          'На почту отправлено письмо. Перейдите по ссылке в письме и введите новый пароль',
        );
}

class DeleteAccountNotice extends Notice {
  const DeleteAccountNotice()
      : super(
          'Вы действительно хотите удалить аккаунт?',
        );
}

class SendEmailAgainNotice extends Notice {
  const SendEmailAgainNotice()
      : super(
          'Указанная почта не подтверждена. Отправить письмо ещё раз?',
        );
}
