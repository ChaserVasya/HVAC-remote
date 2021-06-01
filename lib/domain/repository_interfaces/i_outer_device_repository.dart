import 'package:my_mqtt/domain/entities/outer_device.dart';

interface IOuterDeviceRepository {
  Future<OuterDevice> getOuterDevice();
}
