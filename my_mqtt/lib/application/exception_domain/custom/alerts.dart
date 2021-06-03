import 'package:my_mqtt/application/exception_domain/common_alerts.dart';
import 'package:my_mqtt/application/exception_domain/custom/custom_exception.dart';
import 'package:my_mqtt/application/exception_domain/custom/exceptions.dart';
import 'package:my_mqtt/application/exception_domain/exception_alert.dart';

ExceptionAlert switchCustomExceptionAlert(CustomException e) {
  if (e is EmailVerifyingException) {
    return const _EmailVerifyingAlert();
  } else {
    return UnhandledAlert(e.message);
  }
}

class _EmailVerifyingAlert extends ExceptionAlert {
  const _EmailVerifyingAlert()
      : super(
          titleForUser: 'Почта не подтверждена',
          textForUser:
              'Почта, привязанная к реквизитам, должна быть подтверждена. Перейдите по ссылке в письме, автоматически отправленном вам на почту. Отправить сообщение повторно?',
        );
}
