import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hvac_remote_client/application/navigator.dart';
import 'package:hvac_remote_client/presentation/templates/page_template.dart';

class PushingField extends StatelessWidget {
  const PushingField(
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
      isPushedFieldPage: false,
      controller: controller,
      labelText: labelText,
    );
  }
}

class PushedFieldPage extends StatefulWidget {
  const PushedFieldPage(
    this.labelText,
    this.controller, {
    Key? key,
  }) : super(key: key);
  final String labelText;

  final TextEditingController controller;

  @override
  _PushedFieldPageState createState() => _PushedFieldPageState();
}

class _PushedFieldPageState extends State<PushedFieldPage> {
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
        isPushedFieldPage: true,
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
    required this.isPushedFieldPage,
    Key? key,
  }) : super(key: key);

  final bool isPushedFieldPage;
  final String labelText;
  final TextEditingController controller;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofocus: (isPushedFieldPage) ? true : false,
      onEditingComplete: (isPushedFieldPage) ? (() => navigator.pop(context)) : null,
      onTap: (isPushedFieldPage) ? null : (() => _pushPushedFieldPage(context)),
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: labelText,
      ),
      controller: controller,
      maxLength: 50,
      maxLengthEnforcement: MaxLengthEnforcement.enforced,
    );
  }

  void _pushPushedFieldPage(BuildContext context) {
    navigator.push(
      MaterialPageRoute<void>(
        builder: (_) => PushedFieldPage(labelText, controller),
      ),
    );
  }
}
