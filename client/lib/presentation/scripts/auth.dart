import 'package:hvac_remote_client/application/dialogs/content/field.dart';
import 'package:hvac_remote_client/application/dialogs/content/notice.dart';
import 'package:hvac_remote_client/application/navigator.dart';
import 'package:hvac_remote_client/presentation/dialogs/field_dialog.dart';
import 'package:hvac_remote_client/application/exception/exception_handler.dart';
import 'package:hvac_remote_client/presentation/dialogs/notice_dialog.dart';
import 'package:hvac_remote_client/application/routes.dart';
import 'package:hvac_remote_client/domain/services/auth.dart';

final AuthService _auth = AuthService();

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
