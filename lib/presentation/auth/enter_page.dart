import 'package:flutter/material.dart';
import 'package:my_mqtt/presentation/routes_names.dart';
import 'package:my_mqtt/presentation/templates/change_page_button_templates.dart';
import 'package:my_mqtt/presentation/templates/page_template.dart';

class EnterPage extends StatelessWidget {
  const EnterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      mode: PageModes.beforeAuth,
      body: Column(
        children: [
          ChangePageElevatedButton('Войти', RoutesNames.beforeAuth.login, context),
          ChangePageElevatedButton('Зарегистрироваться', RoutesNames.beforeAuth.accountCreate, context),
        ],
      ),
    );
  }
}
