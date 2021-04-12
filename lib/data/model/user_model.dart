import 'package:my_mqtt/data/api/api.dart';

class UserModel with Authentication {
  static final UserModel _user = UserModel._();
  factory UserModel() => _user;
  UserModel._();
}

mixin Authentication {
  bool isAuthenticated;
  bool checkPassword(String inputPassword) {
    isAuthenticated = _api.execute(inputPassword, Task.checkPassword);
    return isAuthenticated;
  }

  Api _api = Api();
}
