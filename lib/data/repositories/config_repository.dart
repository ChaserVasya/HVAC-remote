import 'dart:convert';

import 'package:my_mqtt/data/daos/mqtt_dao.dart';
import 'package:my_mqtt/domain/entities/config.dart';
import 'package:my_mqtt/domain/repository_interfaces/i_config_repository.dart';

class ConfigRepository implements IConfigRepository {
  MqttDao _mqtt = MqttDao();

  @override
  Future<Config> getNewConfig() async => Config.fromJson(jsonDecode(await _mqtt.getConfig()));
}
