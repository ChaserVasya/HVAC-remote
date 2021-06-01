import 'package:my_mqtt/presentation/pages/test/states.dart';
import 'package:my_mqtt/presentation/pages/test/view_model.dart';

class TestUseCase {
  TestUseCase(this._viewModel);

  final TestViewModel _viewModel;

  void handle(TestEvents event) async {
    switch (event) {
      case TestEvents.checkOuterDeviceStatus:
        _viewModel.checkOuterDeviceSub = _outerDevice.checkOuterDeviceSub();

        break;
      case TestEvents.startStream:
        _viewModel.switchValue = true;
        _viewModel.stream = await _outerDevice.getStream();
        break;

      case TestEvents.stopStream: // replaces [Widget] with [StreamBuilder]
        _viewModel.switchValue = false;
        stopStream
        break;
    }
  }
}
