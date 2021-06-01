import 'package:my_mqtt/domain/entities/config.dart';

abstract class IConfigRepository {
  Future<Config> getNewConfig();
}
