import 'package:flutter/material.dart';
import 'package:my_mqtt/application/exception_domain/common/exception_alert.dart';

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

void showExceptionDialog(ExceptionAlert alert, GlobalKey<NavigatorState> navigatorKey) {
  showDialog(
    context: navigatorKey.currentContext!,
    builder: (context) => ExceptionDialog(context, alert),
  );
}
