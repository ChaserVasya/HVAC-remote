import 'package:flutter/material.dart';
import 'package:hvac_remote_client/application/navigator.dart';
import 'package:hvac_remote_client/application/routes.dart';
import 'package:hvac_remote_client/presentation/template/faded_logo.dart';
import 'package:hvac_remote_client/presentation/template/page_template.dart';

class EnterPage extends StatelessWidget {
  const EnterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const FadedLogo(),
          const Padding(padding: EdgeInsets.only(top: 80)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton(
                  child: const Text('Войти'),
                  onPressed: () => navigator.pushReplacementNamed(RoutesNames.signIn),
                ),
                OutlinedButton(
                  onPressed: () => navigator.pushReplacementNamed(RoutesNames.accountCreate),
                  child: const Text('Зарегистрироваться'),
                ),
              ],
            ),
          ),
          _policiesText,
        ],
      ),
    );
  }
}

const _policiesText = Text(
  'Авторизуясь вы соглашаетесь с ещё не существующими условиями пользования и политикой конфиденциальности компании COMPANY_NAME*',
  textAlign: TextAlign.center,
  style: TextStyle(color: Colors.black45),
);
