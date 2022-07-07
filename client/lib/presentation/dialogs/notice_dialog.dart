import 'package:flutter/material.dart';
import 'package:hvac_remote_client/application/dialogs/content/interfaces/notice.dart';
import 'package:hvac_remote_client/application/navigator.dart';

class NoticeDialog extends AlertDialog {
  NoticeDialog(
    BuildContext context,
    NoticeDialogContent notice, {
    String? buttonLabel,
    Key? key,
  }) : super(
          key: key,
          content: Text(
            notice.message,
            textAlign: TextAlign.left,
          ),
          actions: [
            ElevatedButton(
              child: Text((buttonLabel == null) ? 'Продолжить' : buttonLabel),
              onPressed: () => navigator.pop<bool>(true),
            ),
          ],
        );
}

Future<bool> showNoticeDialog(NoticeDialogContent notice) async {
  final result = await showDialog<bool>(
    context: navigator.context,
    builder: (navigatorContext) => NoticeDialog(
      navigatorContext,
      notice,
    ),
  );

  return (result == null) ? false : true;
}
