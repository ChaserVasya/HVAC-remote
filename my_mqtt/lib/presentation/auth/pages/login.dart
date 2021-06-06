import 'package:flutter/material.dart';
import 'package:my_mqtt/presentation/auth/view_model.dart';
import 'package:my_mqtt/application/routes_names.dart';
import 'package:my_mqtt/presentation/templates/change_page_button_templates.dart';
import 'package:my_mqtt/presentation/templates/text_form_form_template.dart';
import 'package:my_mqtt/presentation/templates/page_template.dart';
import 'package:provider/provider.dart';

class LogingPage extends StatelessWidget {
  const LogingPage({Key? key}) : super(key: key);

  final String buttonText = 'Нет аккаунта? Зарегистрироваться';
  final String routeName = RoutesNames.accountCreate;

  final bool drawerIsNeeded = false;

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      afterAuth: false,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/logo.png', width: 150, height: 150),
            const Padding(padding: EdgeInsets.only(top: 80)),
            const _LoginForm(),
            ChangePageTextButton(buttonText, routeName, context),
          ],
        ),
      ),
    );
  }
}

class _LoginForm extends StatelessWidget {
  const _LoginForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: context.watch<AuthViewModel>().logining,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return _NoneLogining();
          case ConnectionState.waiting:
            return const CircularProgressIndicator();
          case ConnectionState.active:
            return const CircularProgressIndicator();
          case ConnectionState.done:
            if (snapshot.hasError) {
              print('hasError');
              return _NoneLogining();
            } else {
              print('has not Error');
              Future.delayed(Duration.zero, () => Navigator.pushReplacementNamed(context, RoutesNames.home));
              return const _SuccessLogIn();
            }
        }
      },
    );
  }
}

class _NoneLogining extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormFieldTemplate('E-mail', emailController),
        TextFormFieldTemplate('Пароль', passwordController),
        _buildLogInButton(context),
      ],
    );
  }

  Widget _buildLogInButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        context.read<AuthViewModel>().logIn(emailController.text, passwordController.text);
      },
      child: const Text('Войти'),
    );
  }
}

class _SuccessLogIn extends StatelessWidget {
  const _SuccessLogIn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Icon(Icons.check_circle, color: Colors.green);
  }
}
