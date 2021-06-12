import 'package:flutter/material.dart';

import 'notice.dart';

class NoticeDialog extends AlertDialog {
  NoticeDialog(
    BuildContext context,
    Notice notice, {
    String? buttonLabel,
    Key? key,
  }) : super(
          key: key,
          content: Text(notice.message, textAlign: TextAlign.justify),
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
  Notice notice,
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
