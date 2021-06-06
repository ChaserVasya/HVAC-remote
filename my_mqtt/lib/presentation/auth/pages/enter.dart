import 'package:flutter/material.dart';
import 'package:my_mqtt/application/routes_names.dart';
import 'package:my_mqtt/presentation/templates/change_page_button_templates.dart';
import 'package:my_mqtt/presentation/templates/page_template.dart';

class EnterPage extends StatelessWidget {
  const EnterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      afterAuth: false,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/logo.png', width: 150, height: 150),
          const Padding(padding: EdgeInsets.only(top: 80)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ChangePageElevatedButton('Войти', RoutesNames.login, context),
                ChangePageOutlinedButton('Зарегистрироваться', RoutesNames.accountCreate, context),
              ],
            ),
          ),
          _policiesText,
        ],
      ),
    );
  }
}

//TODO privacy police, terms of service, company name
const _policiesText = Text(
  'Авторизуясь вы соглашаетесь с условиями пользования и политикой конфиденциальности компании COMPANY_NAME',
  textAlign: TextAlign.center,
  style: TextStyle(color: Colors.black45),
);
