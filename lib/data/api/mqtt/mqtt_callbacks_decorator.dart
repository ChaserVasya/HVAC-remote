import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:my_mqtt/application/exceptions.dart';

class MqttCallBacksDecorator {
  int _subCounter = 0;
  int _disCounter = 0;
  int _conCounter = 0;

  MqttCallBacksDecorator();
  MqttServerClient addCallbacks(MqttServerClient client) {
    bool Function(dynamic)? _onBadCertificate = (_) {
      _printWithFrame('BAD CERTIFICATE');
      _printWithFrame(
          'need to check command: securityContext = SecurityContext.defaultContext. if anything instead (like SecyrityContext())- true');
      _printWithFrame('BAD CERTIFICATE');
      return true;
    };

    void _onUnsubscribed(String? text) => _printWithFrame('UNSUBSCRIBED:  $text');
    void _onSubscribeFail(String text) {
      _printWithFrame('SUBSCRIBING FAILED:  $text');
      throw SubscribeFailException;
    }

    void _onConnected() => _printWithFrame('${_conCounter++}CONNECTED');
    void _onDisconnected() => _printWithFrame('${_disCounter++}DISCONNECTED');
    void _onAutoReconnect() => _printWithFrame('AUTORECONNECT');
    void _onSubscribed(String text) => _printWithFrame('${_subCounter++}SUBSCRIBED: $text');

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
