import 'package:flutter/material.dart';
import 'package:my_mqtt/presentation/auth/view_model.dart';
import 'package:my_mqtt/presentation/routes_names.dart';
import 'package:my_mqtt/presentation/templates/change_page_button_templates.dart';
import 'package:my_mqtt/presentation/templates/text_form_form_template.dart';
import 'package:my_mqtt/presentation/templates/page_template.dart';
import 'package:provider/provider.dart';

class AccountCreatePage extends StatelessWidget {
  final String buttonText = 'Уже зарегистрированы? Войти';

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _AccountCreateForm(),
          ChangePageTextButton(buttonText, RoutesNames.login),
        ],
      ),
    );
  }
}

class _AccountCreateForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: context.watch<AuthViewModel>().accountCreating,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return _NoneAccountCreating();
          case ConnectionState.waiting:
            return CircularProgressIndicator();
          case ConnectionState.active:
            return CircularProgressIndicator();
          case ConnectionState.done:
            return _AccountCreated();
        }
      },
    );
  }
}

class _NoneAccountCreating extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormFieldTemplate('E-mail', emailController),
        TextFormFieldTemplate('Пароль', passwordController),
        _AccountCreateButton(emailController, passwordController),
      ],
    );
  }
}

class _AccountCreated extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _SuccessAccountCreateText(),
        _SendVerifyingEmailButton(),
      ],
    );
  }
}

class _SuccessAccountCreateText extends StatelessWidget {
  final String text = 'Аккаунт создан. Для завершения регистрации пройдите по ссылке в письме, отправленном на почту';

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green,
      child: Text(text),
    );
  }
}

class _AccountCreateButton extends StatelessWidget {
  const _AccountCreateButton(this.emailController, this.passwordController);

  final TextEditingController emailController;
  final TextEditingController passwordController;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => context.watch<AuthViewModel>().createAccount(
            emailController.text,
            passwordController.text,
          ),
      child: Text('Создать'),
    );
  }
}

class _SendVerifyingEmailButton extends StatelessWidget {
  final String text = 'Отправить подтверждающее письмо ещё раз';
  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: Text(text),
      onPressed: context.watch<AuthViewModel>().sendVerifyingEmail,
    );
  }
}
