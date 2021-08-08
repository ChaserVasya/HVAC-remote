import 'package:flutter/material.dart';
import 'package:hvac_remote_client/application/dialogs/content/interfaces/notice.dart';

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
              onPressed: () => Navigator.pop<bool>(context, true),
            ),
          ],
        );
}

Future<bool> showNoticeDialog(
  BuildContext navigatorDescendalContext,
  NoticeDialogContent notice,
) async {
  final result = await showDialog<bool>(
    context: navigatorDescendalContext,
    builder: (navigatorContext) => NoticeDialog(
      navigatorContext,
      notice,
    ),
  );

  return (result == null) ? false : true;
}
