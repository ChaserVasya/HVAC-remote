import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFormFieldTemplate extends StatelessWidget {
  const TextFormFieldTemplate(
    this.labelText,
    this.controller, {
    Key? key,
    this.errorText,
  }) : super(key: key);

  final String? errorText;
  final String labelText;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: labelText,
        errorText: errorText,
      ),
      controller: controller,
      maxLength: 100,
      maxLengthEnforcement: MaxLengthEnforcement.enforced,
    );
  }
}
