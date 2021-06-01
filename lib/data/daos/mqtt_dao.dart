import 'package:my_mqtt/data/api/mqtt/mqtt_db.dart';
import 'package:my_mqtt/data/dto.dart';
import 'package:my_mqtt/domain/enums.dart';

class MqttDao {
  MqttDb _db = MqttDb();
  Dto _dto = Dto();

  Future<void> send(String data, Endpoints endpoint) async {
    _db.send(_dto.string2payload(data), endpoint);
  }

  Future<String> getConfig() async {
    return _dto.accumulated2strings(await _db.receiveConfig()).last;
  }

  Future<Stream<String>> getCommandStream() async {
    var inStream = await _db.getCommandStream();
    Stream<String> outStream = inStream!.map((event) => _dto.event2string(event));
    return outStream;
  }

  void closeCommandStream() {
    _db.disposeCommandStream();
  }
}
