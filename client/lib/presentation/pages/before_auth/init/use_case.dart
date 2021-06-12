import 'package:flutter/widgets.dart';
import 'package:hvac_remote_client/application/throwed/exception_handler.dart';
import 'package:hvac_remote_client/application/routes.dart';
import 'package:hvac_remote_client/application/service_locator.dart';
import 'package:hvac_remote_client/presentation/pages/before_auth/init/view_model.dart';

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
