import 'package:flutter/material.dart';
import 'package:my_mqtt/domain/state/password_page_state.dart';

import 'model/my_page.dart';
import 'package:provider/provider.dart';

class PasswordPage extends StatelessWidget {
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    void _enterToApp(_) {
      Navigator.pushNamed(context, '/SensorsPage');
    }

    if (context.watch<PasswordPageState>().needToEnterToApp) {
      WidgetsBinding.instance.addPostFrameCallback(_enterToApp);
    }

    return MyPage(
      drawerNotNeeded: true,
      title: 'Авторизация',
      body: Container(
        margin: EdgeInsets.all(16),
        child: Column(
          children: [
            Text('В качестве пароля введите название концерна-изготовителя вентиляционной установки.'),
            TextFormField(controller: controller, maxLength: 30),
            if (context.watch<PasswordPageState>().needToDisplayTextAboutWrongPassword)
              Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 8),
                    child: Text('Неправильный пароль', style: TextStyle(color: Colors.red)),
                  ),
                  RaisedButton(
                    child: Text('Войти'),
                    onPressed: () => context.read<PasswordPageState>().checkPassword(controller.text),
                  ),
                ],
              )
            else
              RaisedButton(
                child: Text('Войти'),
                onPressed: () => context.read<PasswordPageState>().checkPassword(controller.text),
              ),
          ],
        ),
      ),
    );
  }
}
