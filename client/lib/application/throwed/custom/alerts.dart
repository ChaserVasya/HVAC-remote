import 'package:flutter/material.dart';
import 'package:hvac_remote_client/application/throwed/common/exception_alert.dart';
import 'package:hvac_remote_client/domain/services/auth.dart';

class EmailNotVerifiedAlert extends ExceptionAlert {
  EmailNotVerifiedAlert()
      : super(
          titleForUser: 'Почта не подтверждена',
          textForUser:
              'Почта должна быть подтверждена. Перейдите по ссылке в письме, автоматически отправленном вам на почту. Отправить сообщение повторно?',
          actionsBuilder: (context) => [
            ElevatedButton(
              child: const Text('Отправить'),
              onPressed: () async {
                AuthService().sendEmailVerification();
                Navigator.pop(context);
              },
            )
          ],
        );
}

class IncorrectrepeatedAlert extends ExceptionAlert {
  const IncorrectrepeatedAlert()
      : super(
          titleForUser: 'Пароли не совпадают',
          textForUser: 'Пароль и повторный пароль не совпадают. Перепроверьте и повторите.',
        );
}

class EmptyPasswordAlert extends ExceptionAlert {
  const EmptyPasswordAlert()
      : super(
          titleForUser: 'Недопустимый пароль',
          textForUser: 'Пустой пароль недопустим.',
        );
}

class RoleNotChangedAlert extends ExceptionAlert {
  const RoleNotChangedAlert()
      : super(
          titleForUser: 'Неверный пароль',
          textForUser:
              'Роль не изменена. При частых попытках сменить роль доступ к серверу будет на некоторые время заблокирован.',
        );
}
