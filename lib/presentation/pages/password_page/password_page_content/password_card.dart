import 'package:flutter/material.dart';
import 'package:my_mqtt/domain/state/password_page_domain.dart';
import 'package:my_mqtt/presentation/pages/model/card_template.dart';

import 'package:provider/provider.dart';

class PasswordCard extends StatelessWidget {
  const PasswordCard({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget choosePasswordAuthResultWidget() {
      switch (context.watch<PasswordPageDomain>().passwordPageState) {
        case PasswordPageState.wrongPasswordState:
          return _WrongPasswordState();
        case PasswordPageState.notEnteredPasswordState:
          return _NotEnteredPasswordState();
        default:
          assert(false, context.watch<PasswordPageDomain>().passwordPageState.toString());
          return null;
      }
    }

    return CardTemplate(
      child: Column(
        children: [
          Text('В качестве пароля введите название концерна-изготовителя вентиляционной установки.'),
          TextFormField(controller: context.watch<PasswordPageDomain>().passwordController, maxLength: 30),
          choosePasswordAuthResultWidget(),
          RaisedButton(
            child: Text('Войти'),
            onPressed: () => context.read<PasswordPageDomain>().enterToApp(context),
          ),
        ],
      ),
    );
  }
}

class _WrongPasswordState extends StatelessWidget {
  const _WrongPasswordState({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      child: Text('Неправильный пароль', style: TextStyle(color: Colors.red)),
    );
  }
}

class _NotEnteredPasswordState extends StatelessWidget {
  const _NotEnteredPasswordState({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(width: 0.0, height: 0.0);
  }
}
