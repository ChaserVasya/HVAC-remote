import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:my_mqtt/presentation/auth/view_model.dart';
import 'package:my_mqtt/application/routes_names.dart';
import 'package:my_mqtt/presentation/templates/change_page_button_templates.dart';
import 'package:my_mqtt/presentation/templates/text_form_form_template.dart';
import 'package:my_mqtt/presentation/templates/page_template.dart';
import 'package:provider/provider.dart';

class AccountCreatePage extends StatelessWidget {
  const AccountCreatePage({Key? key}) : super(key: key);

  final String buttonText = 'Уже зарегистрированы? Войти';

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
            const _AccountCreateForm(),
            ChangePageTextButton(buttonText, RoutesNames.login, context),
          ],
        ),
      ),
    );
  }
}

class _AccountCreateForm extends StatelessWidget {
  const _AccountCreateForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: context.watch<AuthViewModel>().accountCreating,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return _NoneAccountCreating();
          case ConnectionState.waiting:
            return const CircularProgressIndicator();
          case ConnectionState.active:
            return const CircularProgressIndicator();
          case ConnectionState.done:
            return const _AccountCreated();
        }
      },
    );
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
        _buildAccountCreateButton(context),
      ],
    );
  }

  Widget _buildAccountCreateButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () => context.watch<AuthViewModel>().createAccount(
            emailController.text,
            passwordController.text,
            repeateController.text,
          ),
      child: const Text('Создать'),
    );
  }
}

class _AccountCreated extends StatelessWidget {
  const _AccountCreated({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildSuccessAccountCreateText(),
        _buildVerifyingEmailSendButton(context),
      ],
    );
  }

  Widget _buildSuccessAccountCreateText() {
    const String text = 'Аккаунт создан. Для завершения регистрации пройдите по ссылке в письме, отправленном на почту';
    return const ColoredBox(
      color: Colors.green,
      child: Text(text),
    );
  }

  Widget _buildVerifyingEmailSendButton(context) {
    const String text = 'Отправить подтверждающее письмо ещё раз';
    return TextButton(
      child: const Text(text),
      onPressed: context.watch<AuthViewModel>().sendVerifyingEmail,
    );
  }
}
