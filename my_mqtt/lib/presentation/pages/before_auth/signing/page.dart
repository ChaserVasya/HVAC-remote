import 'package:flutter/material.dart';
import 'package:my_mqtt/application/routes.dart';
import 'package:my_mqtt/presentation/scripts/auth.dart';
import 'package:my_mqtt/presentation/templates/text_form_field_template.dart';
import 'package:my_mqtt/presentation/templates/page_template.dart';
import 'package:provider/provider.dart';

import 'use_case.dart';
import 'view_model.dart';

late BuildContext _pageContext;

class SigningPage extends StatelessWidget {
  const SigningPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _pageContext = context;
    return PageTemplate(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Padding(padding: EdgeInsets.only(top: 49)),
          Image.asset('assets/images/logo.png', width: 150, height: 150),
          const Padding(padding: EdgeInsets.only(top: 80)),
          const _LoginForm(),
          TextButton(
            child: const Text('Нет аккаунта? Зарегистрироваться'),
            onPressed: () => Navigator.pushReplacementNamed(context, RoutesNames.accountCreate),
          ),
          TextButton(
            child: const Text('Сбросить пароль'),
            onPressed: () => resetPassword(context),
          ),
        ],
      ),
    );
  }
}

class _LoginForm extends StatelessWidget {
  const _LoginForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    late Widget body;

    switch (context.watch<SigningViewModel>().state) {
      case SigningStates.none:
        body = _None();
        break;
      case SigningStates.sending:
        body = const CircularProgressIndicator();
        break;
      case SigningStates.signed:
        body = const Icon(Icons.check_circle, color: Colors.green);
        break;
    }

    return body;
  }
}

class _None extends StatelessWidget {
  _None({Key? key}) : super(key: key);

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormFieldTemplate('E-mail', emailController),
        TextFormFieldTemplate('Пароль', passwordController),
        ElevatedButton(
          onPressed: () {
            _pageContext.read<SigningViewModel>().signIn(
                  emailController.text,
                  passwordController.text,
                  _pageContext,
                );
          },
          child: const Text('Войти'),
        ),
      ],
    );
  }
}
