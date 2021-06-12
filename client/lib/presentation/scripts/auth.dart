import 'package:flutter/material.dart';
import 'package:hvac_remote_client/application/action/contents.dart';
import 'package:hvac_remote_client/application/action/field_dialog.dart';
import 'package:hvac_remote_client/application/throwed/exception_handler.dart';
import 'package:hvac_remote_client/application/notice/notice_dialog.dart';
import 'package:hvac_remote_client/application/notice/notices.dart';
import 'package:hvac_remote_client/application/routes.dart';
import 'package:hvac_remote_client/domain/services/auth.dart';

final AuthService _auth = AuthService();

void resetPassword(BuildContext context) async {
  try {
    String? email;
    if (!_auth.wasAuthed) email = await showFieldDialog(context, ResetPasswordContent());
    if (email == null) return;
    await _auth.sendPasswordResetEmail(email);
    showNoticeDialog(context, const PasswordResetEmailSendedNotice());
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
