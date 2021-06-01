import 'package:my_mqtt/data/daos/mqtt_dao.dart';
import 'package:my_mqtt/data/repositories/config_repository.dart';
import 'package:my_mqtt/domain/entities/outer_device.dart';
import 'package:my_mqtt/domain/repository_interfaces/i_outer_device_repository.dart';
import 'package:my_mqtt/application/service_locator.dart';

class OuterDeviceRepository implements IOuterDeviceRepository {
  OuterDevice? _device;
  final MqttDao _mqtt = MqttDao();

  @override
  Future<OuterDevice> getOuterDevice() async {
    var device = _device;
    if (device == null) {
      var outerDeviceIsOnline = (await sl<ConfigRepository>().getNewConfig()).outerDeviceIsOnline;
      device = OuterDevice(outerDeviceIsOnline);
      _device = device;
    }
    return device;
  }
}
