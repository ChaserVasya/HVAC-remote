import 'package:flutter/material.dart';
import 'package:hvac_remote_client/application/navigator.dart';
import 'package:hvac_remote_client/application/routes.dart';
import 'package:hvac_remote_client/presentation/script/auth.dart';
import 'package:hvac_remote_client/presentation/template/pushing_field.dart';
import 'package:hvac_remote_client/presentation/template/page_template.dart';
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
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: Image.asset('assets/images/logo.png', height: 150, width: 150),
          ),
          const _LoginForm(),
          Column(
            children: [
              TextButton(
                child: const Text('Нет аккаунта? Зарегистрироваться'),
                onPressed: () => navigator.pushReplacementNamed(RoutesNames.accountCreate),
              ),
              TextButton(
                child: const Text('Сбросить пароль'),
                onPressed: () => resetPassword(),
              ),
            ],
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
        PushingField('E-mail', emailController),
        PushingField('Пароль', passwordController),
        ElevatedButton(
          onPressed: () {
            _pageContext.read<SigningViewModel>().signIn(
                  emailController.text,
                  passwordController.text,
                );
          },
          child: const Text('Войти'),
        ),
      ],
    );
  }
}
