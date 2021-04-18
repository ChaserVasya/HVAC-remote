import 'package:flutter/material.dart';
import 'package:my_mqtt/data/enums.dart';
import 'package:my_mqtt/domain/domain_mediator.dart';

abstract class DomainComponent extends ChangeNotifier {
  DomainComponent(this._domainMediator);
  final DomainMediator _domainMediator;

  notifyAboutBadConnection() {
    _domainMediator.notify(Senders.authComponent, DomainEvents.badConnection);
  }
}
