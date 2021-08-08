import 'package:hvac_remote_client/application/dialogs/content/interfaces/field.dart';

class ResetPasswordContent implements FieldDialogContent {
  const ResetPasswordContent();

  @override
  final String title = 'Сброс пароля';

  @override
  final String labelText = 'Email';

  @override
  final String buttonText = 'Отправить';

  @override
  final String message = 'На указанную почту будет отправлено письмо с новым паролем';
}
