import 'package:flutter/material.dart';

import 'common/exception_alert.dart';

class ExceptionDialog extends AlertDialog {
  ExceptionDialog(
    BuildContext context,
    ExceptionAlert alert, {
    Key? key,
  }) : super(
          scrollable: true,
          key: key,
          title: Text(alert.titleForUser, textAlign: TextAlign.justify),
          actions: (alert.actionsBuilder != null) ? alert.actionsBuilder!(context) : null,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(alert.textForUser, textAlign: TextAlign.justify),
              if (alert.details != null)
                ExpansionTile(
                  title: const Text('Показать детали'),
                  children: [Text(alert.details!, textAlign: TextAlign.justify)],
                ),
            ],
          ),
        );
}

void showExceptionDialog(
  ExceptionAlert alert,
  BuildContext navigatorDescendantContext,
) {
  showDialog(
    context: navigatorDescendantContext,
    builder: (navigatorContext) => ExceptionDialog(navigatorContext, alert),
  );
}
