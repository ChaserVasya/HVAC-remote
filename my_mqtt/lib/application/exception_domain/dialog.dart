import 'package:flutter/material.dart';
import 'package:my_mqtt/application/exception_domain/exception_alert.dart';

class ExceptionDialog extends AlertDialog {
  ExceptionDialog(
    ExceptionAlert alert, {
    Key? key,
  }) : super(
          key: key,
          title: Text(alert.titleForUser),
          content: Column(
            children: [
              Text(alert.textForUser),
              if (alert.details != null)
                SingleChildScrollView(
                  child: ExpansionTile(
                    title: const Text('Показать детали'),
                    children: [Text(alert.details!)],
                  ),
                ),
            ],
          ),
        );
}

void showExceptionDialog(ExceptionAlert alert, GlobalKey<NavigatorState> navigatorKey) {
  showDialog(
    context: navigatorKey.currentContext!,
    builder: (_) => ExceptionDialog(alert),
  );
}
