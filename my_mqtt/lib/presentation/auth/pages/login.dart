import 'package:flutter/material.dart';
import 'package:my_mqtt/presentation/auth/view_model.dart';
import 'package:my_mqtt/presentation/routes_names.dart';
import 'package:my_mqtt/presentation/templates/change_page_button_templates.dart';
import 'package:my_mqtt/presentation/templates/text_form_form_template.dart';
import 'package:my_mqtt/presentation/templates/page_template.dart';
import 'package:provider/provider.dart';

class LogingPage extends StatelessWidget {
  final String buttonText = 'Нет аккаунта? Зарегистрироваться';
  final String routeName = RoutesNames.accountCreate;

  final bool drawerIsNeeded = false;

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      body: Column(
        children: [
          _LoginForm(),
          ChangePageTextButton(buttonText, routeName),
        ],
      ),
    );
  }
}

class _LoginForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: context.watch<AuthViewModel>().logining,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return _NoneLogining();
          case ConnectionState.waiting:
            return CircularProgressIndicator();

          case ConnectionState.active:
            return CircularProgressIndicator();

          case ConnectionState.done:
            Navigator.pushNamed(context, RoutesNames.homePage);
            return _SuccessLogIn();
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
        _LogInButton(emailController, passwordController),
      ],
    );
  }
}

class _SuccessLogIn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Icon(Icons.check_circle, color: Colors.green);
  }
}

class _LogInButton extends StatelessWidget {
  const _LogInButton(this.emailController, this.passwordController);
  final TextEditingController emailController;
  final TextEditingController passwordController;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        context.read<AuthViewModel>().logIn(emailController.text, passwordController.text);
      },
      child: Text('Войти'),
    );
  }
}
