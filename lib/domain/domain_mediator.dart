import 'package:my_mqtt/data/enums.dart';

abstract class DomainMediator {
  void notify(Senders sender, DomainEvents event);
}
