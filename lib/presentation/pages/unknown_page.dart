import 'package:flutter/material.dart';
import 'package:my_mqtt/presentation/pages/model/page_template.dart';

class UnknownPage extends StatelessWidget {
  final String title = 'Ошибка';

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      title: title,
      body: Text('''
Данная страница открывается если запрошена несуществующая страница
  '''),
    );
  }
}
