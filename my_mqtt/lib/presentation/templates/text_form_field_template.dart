import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_mqtt/presentation/templates/page_template.dart';

class TextFormFieldTemplate extends StatelessWidget {
  const TextFormFieldTemplate(
    this.labelText,
    this.controller, {
    Key? key,
  }) : super(key: key);

  final String labelText;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    FocusScope.of(context).unfocus();
    return _TextFormField(
      isTextFormFieldPage: false,
      controller: controller,
      labelText: labelText,
    );
  }
}

class TextFormFieldPage extends StatefulWidget {
  const TextFormFieldPage(
    this.labelText,
    this.controller, {
    Key? key,
  }) : super(key: key);
  final String labelText;

  final TextEditingController controller;

  @override
  _TextFormFieldPageState createState() => _TextFormFieldPageState();
}

class _TextFormFieldPageState extends State<TextFormFieldPage> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    return PageTemplate(
      resizeToAvoidBottomInset: true,
      body: _TextFormField(
        isTextFormFieldPage: true,
        controller: widget.controller,
        labelText: widget.labelText,
      ),
    );
  }

  @override
  void deactivate() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.deactivate();
  }
}

class _TextFormField extends StatelessWidget {
  const _TextFormField({
    required this.labelText,
    required this.controller,
    required this.isTextFormFieldPage,
    Key? key,
  }) : super(key: key);

  final bool isTextFormFieldPage;
  final String labelText;
  final TextEditingController controller;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofocus: (isTextFormFieldPage) ? true : false,
      onEditingComplete: (isTextFormFieldPage) ? (() => Navigator.pop(context)) : null,
      onTap: (isTextFormFieldPage) ? null : (() => _pushTextFormFieldPage(context)),
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: labelText,
      ),
      controller: controller,
      maxLength: 50,
      maxLengthEnforcement: MaxLengthEnforcement.enforced,
    );
  }

  void _pushTextFormFieldPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) => TextFormFieldPage(labelText, controller),
      ),
    );
  }
}
