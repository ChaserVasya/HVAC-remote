import 'package:flutter/material.dart';

import 'package:hvac_remote_client/application/routes.dart';

import 'package:hvac_remote_client/presentation/scripts/auth.dart';

import 'package:hvac_remote_client/presentation/templates/page_template.dart';
import 'package:hvac_remote_client/presentation/view_models/role.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const PageTemplate(
      appBarTitle: 'Настройки',
      body: _Ready(),
    );
  }
}

class _Ready extends StatelessWidget {
  const _Ready({Key? key}) : super(key: key);

  final List<Widget> tileList = const [
    _RoleChange(),
    _ResetPassword(),
    _SignOut(),
    _DeleteUser(),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: tileList.length,
      separatorBuilder: (_, __) => const Divider(),
      itemBuilder: (_, i) => tileList[i],
    );
  }
}

class _RoleChange extends StatelessWidget {
  const _RoleChange({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('Текущая роль: ${context.watch<RoleViewModel>().role.localizedName}'),
      subtitle: const Text(
        'Сменить роль с помощью пароля',
        style: TextStyle(color: Colors.black38),
      ),
      onTap: () => Navigator.pushNamed(context, RoutesNames.roleChange),
    );
  }
}

class _ResetPassword extends StatelessWidget {
  const _ResetPassword({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text('Сбросить пароль'),
      onTap: () => resetPassword(context),
    );
  }
}

class _SignOut extends StatelessWidget {
  const _SignOut({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text('Выйти из аккаунта'),
      onTap: () => signOut(context),
    );
  }
}

class _DeleteUser extends StatelessWidget {
  const _DeleteUser({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text('Удалить аккаунт', style: TextStyle(color: Colors.red)),
      onTap: () => deleteAccount(context),
    );
  }
}
