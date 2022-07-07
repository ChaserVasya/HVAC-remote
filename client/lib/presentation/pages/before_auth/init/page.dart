import 'package:flutter/material.dart';
import 'package:hvac_remote_client/presentation/templates/faded_logo.dart';

import 'package:hvac_remote_client/presentation/templates/page_template.dart';

import 'use_case.dart';

class InitPage extends StatefulWidget {
  InitPage({Key? key}) : super(key: key) {
    InitUseCase();
  }

  @override
  _InitPageState createState() => _InitPageState();
}

class _InitPageState extends State<InitPage> {
  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      body: Image.memory(kTransparentImage),
    );
  }
}
