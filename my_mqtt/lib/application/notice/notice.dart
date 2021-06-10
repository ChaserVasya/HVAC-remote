import 'package:flutter/widgets.dart';

abstract class Notice {
  const Notice(this.message, [this.actionsBuilder]);
  final String message;
  final ActionsBuilder? actionsBuilder;
}

typedef ActionsBuilder = List<Widget> Function(BuildContext context);
