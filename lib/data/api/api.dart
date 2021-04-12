import 'package:my_mqtt/data/api/mqtt/mqtt_api.dart';

class Api {
  MqttApi _mqttApi = MqttApi();

  dynamic execute(data, Task task) {
    switch (task) {
      case Task.checkPassword:
        {
          _mqttApi.send(data, Endpoint.authentication);
          return _mqttApi.receive(Endpoint.config);
        }
    }
  }
}

enum Task {
  checkPassword,
}

enum Endpoint {
  authentication,
  events,
  config,
  test,
  master,
}
