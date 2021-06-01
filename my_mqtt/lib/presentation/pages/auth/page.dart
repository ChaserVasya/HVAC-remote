import 'dart:io';

import 'package:flutter/material.dart';
import 'package:my_mqtt/domain/entities/user.dart';
import 'package:my_mqtt/presentation/pages/auth/viev_model.dart';
import 'package:my_mqtt/presentation/snackbars.dart';
import 'package:my_mqtt/presentation/templates/page_template.dart';
import 'package:stacked/stacked.dart';

class PasswordPage extends StatelessWidget {
  final String title = 'Авторизация';

  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PasswordViewModel>.reactive(
      viewModelBuilder: () => PasswordViewModel(),
      builder: (context, model, child) {
        return PageTemplate(
          drawerIsNeeded: false,
          title: title,
          body: SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('В качестве пароля введите название концерна-изготовителя вентиляционной установки.'),
                TextFormField(controller: controller, maxLength: 30),
                FutureBuilder(
                  future: model.role,
                  builder: (BuildContext context, AsyncSnapshot<Roles> snap) {
                    try {
                      switch (snap.connectionState) {
                        case ConnectionState.none:
                          return _NotCheckedPasswordState(model, controller);
                        case ConnectionState.waiting:
                          return _PasswordCheckingState();
                        case ConnectionState.active:
                          return _PasswordCheckingState();
                        case ConnectionState.done:
                          switch (snap.requireData) {
                            case Roles.watcher:
                              return _TruePasswordState(model, controller);
                            case Roles.unauthed:
                              WidgetsBinding.instance!.addPostFrameCallback((_) {
                                ScaffoldMessenger.of(context).showSnackBar(AuthResultNotReceivedExceptionSnackbar());
                              });
                              return _NotCheckedPasswordState(model, controller);
                          }
                      }
                    } on SocketException {
                      WidgetsBinding.instance!.addPostFrameCallback((_) {
                        ScaffoldMessenger.of(context).showSnackBar(SocketExceptionSnackbar());
                      });
                      return _NotCheckedPasswordState(model, controller);
                    } catch (e) {
                      WidgetsBinding.instance!.addPostFrameCallback((_) {
                        ScaffoldMessenger.of(context).showSnackBar(UndefinedExceptionSnackbar());
                      });
                      print(e.toString());
                      return _NotCheckedPasswordState(model, controller);
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _NotCheckedPasswordState extends StatelessWidget {
  final PasswordViewModel model;
  final TextEditingController controller;
  const _NotCheckedPasswordState(this.model, this.controller, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: Text('Войти'),
      onPressed: () => model.checkPassword(context, controller.text),
    );
  }
}

class _PasswordCheckingState extends StatefulWidget {
  const _PasswordCheckingState({Key? key}) : super(key: key);

  @override
  __PasswordCheckingStateState createState() => __PasswordCheckingStateState();
}

class __PasswordCheckingStateState extends State<_PasswordCheckingState> {
  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator();
  }
}

class _TruePasswordState extends StatelessWidget {
  final PasswordViewModel model;
  final TextEditingController controller;
  const _TruePasswordState(this.model, this.controller, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      Navigator.pushNamed(context, '/TestPage');
    });

    return ElevatedButton(
      child: Text('Войти'),
      onPressed: () => model.checkPassword(context, controller.text),
    );
  }
}

class _WrongPasswordState extends StatelessWidget {
  final PasswordViewModel model;
  final TextEditingController controller;
  const _WrongPasswordState(this.model, this.controller, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(bottom: 8),
          child: Text('Неправильный пароль', style: TextStyle(color: Colors.red)),
        ),
        ElevatedButton(
          child: Text('Войти'),
          onPressed: () => model.checkPassword(context, controller.text),
        ),
      ],
    );
  }
}
