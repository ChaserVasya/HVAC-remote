import 'package:my_mqtt/data/api/data_mapper.dart';
import 'package:my_mqtt/data/api/mqtt/mqtt_api.dart';
import 'package:my_mqtt/data/api/mqtt/mqtt_response_buffer.dart';
import 'package:my_mqtt/data/enums.dart';
import 'package:my_mqtt/internal/exceptions.dart';

bool _findAuthResult(String deviceConf) {
  if (deviceConf.contains(RegExp("true", caseSensitive: false))) return true;
  if (deviceConf.contains(RegExp("false", caseSensitive: false))) return false;
  throw AuthResultNotReceivedException;
}

abstract class Api {
  static Future<bool> checkPassword(String password) async {
    await MqttApi.send(string2Uint8Buffer(password), Endpoints.authentication);
    List<MqttMessageData> msgsPayload = await MqttApi.receive(Endpoints.config);
    String deviceConf = byteData2String(msgsPayload.last.data);
    return _findAuthResult(deviceConf);
  }

  static Future<bool> checkServerConnection() async {
    await MqttApi.receive(Endpoints.config);
    return true;
  }

  static Future<bool> setDataflow() async {
    await MqttApi.setDataflow(Endpoints.commands);
    return true;
  }

  static void disposeDataflow() {
    MqttApi.disposeDataflow();
  }

  static String takeDataFromDataflow() {
    return byteData2String(
      MqttApi.data.last.data,
    );
  }
}
