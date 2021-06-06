import 'package:flutter/material.dart';
import 'package:my_mqtt/application/exception_domain/common/exception_alert.dart';
import 'package:my_mqtt/presentation/auth/view_model.dart';
import 'package:provider/provider.dart';

class EmailNotVerifiedAlert extends ExceptionAlert {
  EmailNotVerifiedAlert()
      : super(
          titleForUser: 'Почта не подтверждена',
          textForUser:
              'Почта должна быть подтверждена. Перейдите по ссылке в письме, автоматически отправленном вам на почту. Отправить сообщение повторно?',
          actionsBuilder: (context) => [
            ElevatedButton(
              child: const Text('Отправить'),
              onPressed: () => context.read<AuthViewModel>().sendVerifyingEmail(),
            )
          ],
        );
}

class IncorrectRepeatedPasswordAlert extends ExceptionAlert {
  const IncorrectRepeatedPasswordAlert()
      : super(
          titleForUser: 'Пароли не совпадают',
          textForUser: 'Пароль и повторный пароль не совпадают. Перепроверьте и повторите.',
        );
}
