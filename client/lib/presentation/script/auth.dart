import 'package:hvac_remote_client/application/dialog/content/field.dart';
import 'package:hvac_remote_client/application/dialog/content/notice.dart';
import 'package:hvac_remote_client/application/injection.dart';
import 'package:hvac_remote_client/application/navigator.dart';
import 'package:hvac_remote_client/domain/service/auth.dart';
import 'package:hvac_remote_client/presentation/dialog/field_dialog.dart';
import 'package:hvac_remote_client/application/exception/exception_handler.dart';
import 'package:hvac_remote_client/presentation/dialog/notice_dialog.dart';
import 'package:hvac_remote_client/application/routes.dart';

final AuthService _auth = getIt.get<AuthService>();

void resetPassword() async {
  try {
    String? email;

    if (!_auth.wasAuthed) {
      email = await showFieldDialog(const ResetPasswordContent());
      if (email == null) return; //user changed his mind about reseting
    }

    await _auth.sendPasswordResetEmail(email);
    showNoticeDialog(const ResetEmailSendedNotice());
  } catch (e, s) {
    ExceptionHandler.handle(e, s);
  }
}

void deleteAccount() async {
  try {
    final ok = await showNoticeDialog(const DeleteAccountNotice());
    if (ok) {
      await _auth.deleteAccount();
      navigator.pushNamedAndRemoveUntil(RoutesNames.signIn, (_) => false);
    }
  } catch (e, s) {
    ExceptionHandler.handle(e, s);
  }
}

void signOut() async {
  try {
    await _auth.signOut();
    navigator.pushNamedAndRemoveUntil(RoutesNames.signIn, (_) => false);
  } catch (e, s) {
    ExceptionHandler.handle(e, s);
  }
}
