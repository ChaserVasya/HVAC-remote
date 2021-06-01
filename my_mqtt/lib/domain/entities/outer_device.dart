import 'package:my_mqtt/data/repositories/config_repository.dart';
import 'package:my_mqtt/application/service_locator.dart';

class OuterDevice {
  OuterDeviceStatuses _status;
  OuterDeviceStatuses get status => _status;

  OuterDevice.fromJson(Map<String, dynamic> json) : this._status = json["status"];

  Future<void> refreshState() async {
    bool isOnline = (await sl<ConfigRepository>().getNewConfig()).outerDeviceIsOnline;
    _setStatus(isOnline);
  }

  OuterDeviceStatuses _setStatus(bool isOnline) {
    switch (isOnline) {
      case true:
        return OuterDeviceStatuses.subscribed;
      case false:
        return OuterDeviceStatuses.unsubscribed;
      default:
        return OuterDeviceStatuses.unchecked;
    }
  }
}

enum OuterDeviceStatuses {
  unchecked,
  subscribed,
  unsubscribed,
}
