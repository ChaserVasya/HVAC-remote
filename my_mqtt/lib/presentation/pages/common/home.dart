import 'package:flutter/material.dart';
import 'package:my_mqtt/presentation/templates/page_template.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const PageTemplate(
      appBarTitle: 'Домашняя страница',
      body: Center(
        child: Text('My cute home'),
      ),
    );
  }
}
