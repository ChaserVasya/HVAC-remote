import 'package:flutter/material.dart';
import 'package:my_mqtt/presentation/pages/before_auth/init/view_model.dart';

import 'package:my_mqtt/presentation/templates/page_template.dart';
import 'package:provider/provider.dart';

class InitPage extends StatelessWidget {
  const InitPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      body: FutureBuilder(
        future: context.watch<InitViewModel>().initializing,
        builder: (futureBuilderContext, snapshot) {
          //! app initializes itself without user action
          if (snapshot.connectionState == ConnectionState.none) {
            WidgetsBinding.instance!.addPostFrameCallback(
              (_) => context.read<InitViewModel>().initialize(futureBuilderContext),
            );
          }
          return const CircularProgressIndicator();
        },
      ),
    );
  }
}
