import 'package:flutter/widgets.dart';
import 'package:my_mqtt/application/exception/exception_handler.dart';
import 'package:my_mqtt/application/routes.dart';
import 'package:my_mqtt/application/service_locator.dart';
import 'package:my_mqtt/presentation/pages/before_auth/init/view_model.dart';

class InitUseCase {
  InitUseCase(this._viewModel);

  final InitViewModel _viewModel;

  Future<void> initialize(BuildContext context) async {
    try {
      _viewModel.initializing = initPlugins();
      await _viewModel.initializing;

      Navigator.pushReplacementNamed(context, RoutesNames.enter);
    } catch (e, s) {
      ExceptionHandler.handle(e, s, context);
    }
  }
}
