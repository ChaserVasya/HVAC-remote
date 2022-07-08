import 'package:flutter/material.dart';
import 'package:hvac_remote_client/application/navigator.dart';
import 'package:hvac_remote_client/application/routes.dart';
import 'package:hvac_remote_client/presentation/template/pushing_field.dart';
import 'package:hvac_remote_client/presentation/template/page_template.dart';
import 'package:provider/provider.dart';

import 'use_case.dart';
import 'view_model.dart';

late BuildContext _pageContext;

class AccountCreatePage extends StatelessWidget {
  const AccountCreatePage({Key? key}) : super(key: key);

  final String buttonText = 'Уже зарегистрированы? Войти';

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
          const _AccountCreateFutureBuilder(),
          TextButton(
            child: const Text('Зарегистрированы? Войти'),
            onPressed: () => navigator.pushReplacementNamed(RoutesNames.signIn),
          ),
        ],
      ),
    );
  }
}

class _AccountCreateFutureBuilder extends StatelessWidget {
  const _AccountCreateFutureBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    late Widget body;

    switch (context.watch<AccountCreateViewModel>().state) {
      case AccountCreateStates.none:
        body = _NoneAccountCreating();
        break;
      case AccountCreateStates.creating:
        body = const CircularProgressIndicator();
        break;
    }

    return body;
  }
}

class _NoneAccountCreating extends StatelessWidget {
  _NoneAccountCreating({Key? key}) : super(key: key);

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController repeateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PushingField('E-mail', emailController),
        PushingField('Пароль', passwordController),
        PushingField('Повторите пароль', repeateController),
        ElevatedButton(
          child: const Text('Создать'),
          onPressed: () => context.read<AccountCreateViewModel>().createAccount(
                emailController.text,
                passwordController.text,
                repeateController.text,
                _pageContext,
              ),
        ),
      ],
    );
  }
}
