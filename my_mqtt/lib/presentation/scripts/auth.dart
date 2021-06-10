import 'package:flutter/material.dart';
import 'package:my_mqtt/application/exception/exception_handler.dart';
import 'package:my_mqtt/application/notice/notice_dialog.dart';
import 'package:my_mqtt/application/notice/notices.dart';
import 'package:my_mqtt/application/routes.dart';
import 'package:my_mqtt/domain/services/auth.dart';

void resetPassword(BuildContext context) async {
  try {
    final AuthService _auth = AuthService();
    await _auth.sendPasswordResetEmail();
    showNoticeDialog(context, const PasswordResetEmailSendedNotice());
  } catch (e, s) {
    ExceptionHandler.handle(e, s, context);
  }
}

void deleteAccount(BuildContext context) async {
  try {
    final AuthService _auth = AuthService();
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
    final AuthService _auth = AuthService();
    await _auth.signOut();
    Navigator.of(context).pushNamedAndRemoveUntil(RoutesNames.signIn, (_) => false);
  } catch (e, s) {
    ExceptionHandler.handle(e, s, context);
  }
}
