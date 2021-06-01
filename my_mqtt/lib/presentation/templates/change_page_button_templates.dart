import 'package:flutter/material.dart';

class ChangePageTextButton extends TextButton {
  ChangePageTextButton(
    String text,
    String routeName,
    BuildContext context, {
    Key? key,
  }) : super(
          key: key,
          onPressed: () => Navigator.pushReplacementNamed(context, routeName),
          child: Text(text),
        );
}

class ChangePageElevatedButton extends ElevatedButton {
  ChangePageElevatedButton(
    String text,
    String routeName,
    BuildContext context, {
    Key? key,
  }) : super(
          key: key,
          onPressed: () => Navigator.pushReplacementNamed(context, routeName),
          child: Text(text),
        );
}
