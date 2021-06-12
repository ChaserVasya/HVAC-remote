import 'package:flutter/material.dart';
import 'package:hvac_remote_client/presentation/templates/page_template.dart';
import 'package:hvac_remote_client/presentation/templates/pushing_field.dart';
import 'package:provider/provider.dart';

import 'use_case.dart';
import 'view_model.dart';

late BuildContext _pageContext;

class RoleChangePage extends StatelessWidget {
  const RoleChangePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _pageContext = context;
    return const PageTemplate(
      appBarTitle: 'Изменение роли',
      body: _StateBuilder(),
    );
  }
}

class _StateBuilder extends StatelessWidget {
  const _StateBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    late final Widget body;

    switch (context.watch<ChangeRoleViewModel>().state) {
      case ChangeRoleStates.none:
        body = _None();
        break;
      case ChangeRoleStates.changing:
        body = const CircularProgressIndicator();
        break;
    }

    return body;
  }
}

class _None extends StatelessWidget {
  _None({Key? key}) : super(key: key);
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PushingField('Пароль', controller),
        ElevatedButton(
          child: const Text('Отправить'),
          onPressed: () => _pageContext.read<ChangeRoleViewModel>().changeRole(
                controller.text,
                _pageContext,
              ),
        ),
      ],
    );
  }
}
