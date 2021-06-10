import 'package:flutter/material.dart';

import 'notice.dart';

class NoticeDialog extends AlertDialog {
  NoticeDialog(
    BuildContext context,
    Notice notice, {
    Key? key,
  }) : super(
          key: key,
          content: Text(notice.message),
          actions: (notice.actionsBuilder == null)
              ? [
                  ElevatedButton(
                    child: const Text('Продолжить'),
                    onPressed: () => Navigator.pop<bool>(context, true),
                  ),
                ]
              : notice.actionsBuilder!(context),
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
