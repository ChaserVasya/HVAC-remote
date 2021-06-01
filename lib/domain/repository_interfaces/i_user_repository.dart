import 'package:my_mqtt/domain/entities/user.dart';

abstract class IUserRepository {
  Future<User> getUser();
}
