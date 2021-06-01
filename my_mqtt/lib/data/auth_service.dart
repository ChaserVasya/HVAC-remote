import 'package:my_mqtt/data/daos/mqtt_dao.dart';
import 'package:my_mqtt/data/dto.dart';
import 'package:my_mqtt/data/repositories/config_repository.dart';
import 'package:my_mqtt/domain/entities/config.dart';
import 'package:my_mqtt/domain/enums.dart';

class Auth {
  MqttDao _remote = MqttDao();
  Dto _dto = Dto();

  Future<bool> checkAuth(String password) async {
    await _remote.send(password, Endpoints.authentication);
    Config config = await ConfigRepository().getNewConfig();
    return config.passwordIsTrue;
  }
}
