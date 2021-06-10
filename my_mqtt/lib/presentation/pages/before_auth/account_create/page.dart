import 'package:flutter/material.dart';
import 'package:my_mqtt/application/routes.dart';
import 'package:my_mqtt/presentation/templates/text_form_field_template.dart';
import 'package:my_mqtt/presentation/templates/page_template.dart';
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
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/logo.png', width: 150, height: 150),
            const Padding(padding: EdgeInsets.only(top: 80)),
            const _AccountCreateFutureBuilder(),
            TextButton(
              child: const Text('Зарегистрированы? Войти'),
              onPressed: () => Navigator.pushReplacementNamed(_pageContext, RoutesNames.signIn),
            ),
          ],
        ),
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
        TextFormFieldTemplate('E-mail', emailController),
        TextFormFieldTemplate('Пароль', passwordController),
        TextFormFieldTemplate('Повторите пароль', repeateController),
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
