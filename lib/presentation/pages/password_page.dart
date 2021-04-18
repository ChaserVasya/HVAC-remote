import 'package:flutter/material.dart';
import 'package:my_mqtt/data/enums.dart';
import 'package:my_mqtt/domain/domain_components/authentication_component.dart';
import 'package:my_mqtt/domain/domain_components/internet_component.dart';
import 'package:my_mqtt/presentation/pages/model/page_template.dart';

import 'package:provider/provider.dart';

class PasswordPage extends StatelessWidget {
  final String title = 'Авторизация';

  final TextEditingController passwordController = TextEditingController();

  ElevatedButton enterButton(BuildContext context) {
    return ElevatedButton(
      child: Text('Войти'),
      onPressed: () => context.read<AuthComponent>().checkPassword(context, passwordController.text),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      drawerIsNeeded: false,
      title: title,
      body: Column(
        children: [
          Text('В качестве пароля введите название концерна-изготовителя вентиляционной установки.'),
          TextFormField(controller: passwordController, maxLength: 30),
          _PasswordPageStateBuilder(enterButton),
        ],
      ),
    );
  }
}

class _PasswordCheckingState extends StatelessWidget {
  const _PasswordCheckingState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator();
  }
}

class _WrongPasswordState extends StatelessWidget {
  const _WrongPasswordState(this.enterButton, {Key? key}) : super(key: key);
  final ElevatedButton Function(BuildContext) enterButton;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(bottom: 8),
          child: Text('Неправильный пароль', style: TextStyle(color: Colors.red)),
        ),
        enterButton(context),
      ],
    );
  }
}

class _NotCheckedPasswordState extends StatelessWidget {
  const _NotCheckedPasswordState(this.enterButton, {Key? key}) : super(key: key);
  final ElevatedButton Function(BuildContext) enterButton;

  @override
  Widget build(BuildContext context) {
    return enterButton(context);
  }
}

class _TruePasswordState extends StatelessWidget {
  const _TruePasswordState(this.enterButton, {Key? key}) : super(key: key);
  final ElevatedButton Function(BuildContext) enterButton;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      Navigator.pushNamed(context, '/TestPage');
    });

    return enterButton(context);
  }
}

class _PasswordPageStateBuilder extends StatefulWidget {
  _PasswordPageStateBuilder(this.enterButton, {Key? key}) : super(key: key);
  final ElevatedButton Function(BuildContext) enterButton;

  @override
  __PasswordPageStateBuilderState createState() => __PasswordPageStateBuilderState();
}

class __PasswordPageStateBuilderState extends State<_PasswordPageStateBuilder> {
  PasswordPageStates passwordPageState = PasswordPageStates.notCheckedPasswordState;

  PasswordPageStates? _definePasswordPageState({required AuthStatuses authStatus, required InternetStatuses internetStatus}) {
    if (internetStatus == InternetStatuses.bad) return PasswordPageStates.notCheckedPasswordState;
    if (internetStatus == InternetStatuses.good && authStatus == AuthStatuses.wrongPassword) return PasswordPageStates.wrongPasswordState;
    if (internetStatus == InternetStatuses.good && authStatus == AuthStatuses.passwordChecking) return PasswordPageStates.passwordCheckingState;
    if (internetStatus == InternetStatuses.good && authStatus == AuthStatuses.passwordNotChecked) return PasswordPageStates.notCheckedPasswordState;
    if (internetStatus == InternetStatuses.good && authStatus == AuthStatuses.truePassword) return PasswordPageStates.truePasswordState;
  }

  Widget _refreshPasswordPageState(PasswordPageStates passwordPageState) {
    switch (passwordPageState) {
      case PasswordPageStates.notCheckedPasswordState:
        return _NotCheckedPasswordState(widget.enterButton);
      case PasswordPageStates.passwordCheckingState:
        return _PasswordCheckingState();
      case PasswordPageStates.wrongPasswordState:
        return _WrongPasswordState(widget.enterButton);
      case PasswordPageStates.truePasswordState:
        return _TruePasswordState(widget.enterButton);
    }
  }

  @override
  Widget build(BuildContext context) {
    PasswordPageStates? newPasswordPageState = _definePasswordPageState(
      authStatus: context.watch<AuthComponent>().authStatus,
      internetStatus: context.watch<InternetComponent>().internetStatus,
    );

    if (newPasswordPageState == null || newPasswordPageState == passwordPageState) {
    } else {
      passwordPageState = newPasswordPageState;
    }
    return _refreshPasswordPageState(passwordPageState);
  }
}
