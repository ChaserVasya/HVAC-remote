import 'package:flutter/material.dart';
import 'package:hvac_remote_client/application/dialogs/content/field.dart';
import 'package:hvac_remote_client/application/dialogs/content/notice.dart';
import 'package:hvac_remote_client/presentation/dialogs/field_dialog.dart';
import 'package:hvac_remote_client/application/exception/exception_handler.dart';
import 'package:hvac_remote_client/presentation/dialogs/notice_dialog.dart';
import 'package:hvac_remote_client/application/routes.dart';
import 'package:hvac_remote_client/domain/services/auth.dart';

final AuthService _auth = AuthService();

void resetPassword(BuildContext context) async {
  try {
    String? email;

    if (!_auth.wasAuthed) {
      email = await showFieldDialog(context, const ResetPasswordContent());
      if (email == null) return; //user changed his mind about reseting
    }

    await _auth.sendPasswordResetEmail(email);
    showNoticeDialog(context, const ResetEmailSendedNotice());
  } catch (e, s) {
    ExceptionHandler.handle(e, s, context);
  }
}

void deleteAccount(BuildContext context) async {
  try {
    final ok = await showNoticeDialog(context, const DeleteAccountNotice());
    if (ok) {
      await _auth.deleteAccount();
      Navigator.pushNamedAndRemoveUntil(context, RoutesNames.signIn, (_) => false);
    }
  } catch (e, s) {
    ExceptionHandler.handle(e, s, context);
  }
}

void signOut(BuildContext context) async {
  try {
    await _auth.signOut();
    Navigator.of(context).pushNamedAndRemoveUntil(RoutesNames.signIn, (_) => false);
  } catch (e, s) {
    ExceptionHandler.handle(e, s, context);
  }
}
