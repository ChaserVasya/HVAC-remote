import 'package:flutter/widgets.dart';

abstract class AlertDialogContent {
  const AlertDialogContent({
    required this.titleForUser,
    required this.textForUser,
    this.details,
    this.actionsBuilder,
  });

  final String titleForUser;
  final String textForUser;
  final String? details;
  final ActionBuilder? actionsBuilder;
}

typedef ActionBuilder = List<Widget> Function(BuildContext);
