import 'package:flutter/material.dart';
import 'package:hvac_remote_client/application/dialog/content/interfaces/alert.dart';

class IncorrectrepeatedAlert implements AlertDialogContent {
  const IncorrectrepeatedAlert();

  @override
  final String titleForUser = 'Пароли не совпадают';
  @override
  final String textForUser = 'Пароль и повторный пароль не совпадают. Перепроверьте и повторите.';
  @override
  final String? details = null;
  @override
  final ActionBuilder? actionsBuilder = null;
}

class RoleNotChangedAlert implements AlertDialogContent {
  const RoleNotChangedAlert();

  @override
  final String titleForUser = 'Неверный пароль';
  @override
  final String textForUser = 'Роль не изменена. Обратите внимание - пробелы считаются за символ.';
  @override
  final String? details = null;
  @override
  final List<Widget> Function(BuildContext)? actionsBuilder = null;
}
