import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:my_mqtt/internal/exceptions.dart';

class MqttCallBacksDecorator {
  const MqttCallBacksDecorator();
  MqttServerClient addCallbacks(MqttServerClient client) {
    bool Function(dynamic)? _onBadCertificate = (_) {
      _printWithFrame('BAD CERTIFICATE');
      _printWithFrame(' need to check command: securityContext = SecurityContext.defaultContext. if anything instead (like SecyrityContext())- correct');
      _printWithFrame('BAD CERTIFICATE');
      return true;
    };

    void _onUnsubscribed(String? text) => _printWithFrame('UNSUBSCRIBED:  $text');
    void _onSubscribeFail(String text) {
      _printWithFrame('SUBSCRIBING FAILED:  $text');
      throw SubscribeFailException;
    }

    void _onConnected() => _printWithFrame('CONNECTED');
    void _onDisconnected() => _printWithFrame('DISCONNECTED');
    void _onAutoReconnect() => _printWithFrame('AUTORECONNECT');
    void _onSubscribed(String text) => _printWithFrame('SUBSCRIBED: $text');

    client
      ..onDisconnected = _onDisconnected
      ..onConnected = _onConnected
      ..onSubscribeFail = _onSubscribeFail
      ..onUnsubscribed = _onUnsubscribed
      ..onAutoReconnect = _onAutoReconnect
      ..onBadCertificate = _onBadCertificate
      ..onSubscribed = _onSubscribed;
    return client;
  }

  // Those callbacks are taken out of addCallbacks method
  // because MqttServerClient can add those callbacks only in
  // MqttServerClient.updates.listen method like argument
  void onDone() => _printWithFrame('DONE');
  void onError(Object obj) => _printWithFrame('ERROR : $obj');

  void _printWithFrame(String text) {
    String equals = '============';
    print('$equals $text $equals');
  }
}
