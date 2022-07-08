/*
For unknown firebase error codes. Firebase hasn`t complete code docs. I had to
find out them by myself. I can`t be sure that I has caught all codes, so, 
I  created this exception alert for unhandled case.
*/
import 'package:hvac_remote_client/application/dialog/content/interfaces/alert.dart';

class UnhandledAlert implements AlertDialogContent {
  const UnhandledAlert([this.details]);

  @override
  final String titleForUser = 'Необработанная ошибка';
  @override
  final String textForUser =
      'Сведения об ошибке будут отправлены на сервер для исправления в следующих версиях.';
  @override
  final String? details;
  @override
  final ActionBuilder? actionsBuilder = null;
}

/*
All dev errors, which can be made: syntax, logic, null check, dirty widget state 
and ets. The meaning of this alert - hot fix it
*/
class DevErrorAlert implements AlertDialogContent {
  const DevErrorAlert();

  @override
  final String titleForUser = 'Программная ошибка';
  @override
  final String textForUser =
      'Сведения об ошибке будут отправлены на сервер для исправления в следующих версиях.';
  @override
  final String? details = null;
  @override
  final ActionBuilder? actionsBuilder = null;
}

class EmptyStringAlert implements AlertDialogContent {
  const EmptyStringAlert();

  @override
  final String titleForUser = 'Пустая строка';
  @override
  final String textForUser = 'Пустая строка недопустима.';
  @override
  final String? details = null;
  @override
  final ActionBuilder? actionsBuilder = null;
}
