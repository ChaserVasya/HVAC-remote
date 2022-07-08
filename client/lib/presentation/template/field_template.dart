import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FieldTemplate extends StatelessWidget {
  const FieldTemplate({
    required this.labelText,
    required this.controller,
    this.onEditingComplete,
    Key? key,
  }) : super(key: key);

  final String labelText;
  final TextEditingController controller;
  final void Function()? onEditingComplete;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onEditingComplete: onEditingComplete,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: labelText,
      ),
      controller: controller,
      maxLength: 50,
      maxLengthEnforcement: MaxLengthEnforcement.enforced,
    );
  }
}
