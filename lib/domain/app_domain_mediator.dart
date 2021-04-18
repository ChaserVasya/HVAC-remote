import 'package:my_mqtt/data/enums.dart';
import 'package:my_mqtt/domain/domain_components/authentication_component.dart';
import 'package:my_mqtt/domain/domain_components/dataflow_component.dart';
import 'package:my_mqtt/domain/domain_components/internet_component.dart';
import 'package:my_mqtt/domain/domain_components/server_connection_component.dart';
import 'package:my_mqtt/domain/domain_components/version_control_component.dart';
import 'package:my_mqtt/domain/domain_mediator.dart';

class AppDomainMediator implements DomainMediator {
  static final AppDomainMediator _appDomainMediator = AppDomainMediator._();

  factory AppDomainMediator() => _appDomainMediator;

  AppDomainMediator._() {
    authComponent = AuthComponent(this);
    connectionComponent = InternetComponent(this);
    versionControlComponent = VersionControlComponent(this);
    serverConnectionComponent = ServerConnectionComponent(this);
    dataflowComponent = DataflowComponent(this);
  }

  late final VersionControlComponent versionControlComponent;
  late final AuthComponent authComponent;
  late final InternetComponent connectionComponent;
  late final ServerConnectionComponent serverConnectionComponent;
  late final DataflowComponent dataflowComponent;

  @override
  void notify(Senders sender, DomainEvents event) {
    if (event == DomainEvents.badConnection) {
      connectionComponent.internetStatus = InternetStatuses.bad;
    }
  }
}
