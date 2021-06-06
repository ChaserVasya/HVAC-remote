import 'package:flutter/widgets.dart';

abstract class ExceptionAlert {
  const ExceptionAlert({
    required this.titleForUser,
    required this.textForUser,
    this.details,
    this.actionsBuilder,
  });

  final String titleForUser;
  final String textForUser;
  final String? details;
  final List<Widget> Function(BuildContext)? actionsBuilder;
}
