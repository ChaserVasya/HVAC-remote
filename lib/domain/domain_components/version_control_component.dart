import 'package:my_mqtt/domain/domain_component.dart';
import 'package:my_mqtt/domain/domain_mediator.dart';

class VersionControlComponent extends DomainComponent {
  static late final VersionControlComponent _versionControlComponent;
  static bool _isInitialized = false;
  bool get isInitialized => _isInitialized;
  VersionControlComponent._(DomainMediator domainMediator) : super(domainMediator);
  factory VersionControlComponent(DomainMediator domainMediator) {
    if (_isInitialized == false) {
      _versionControlComponent = VersionControlComponent._(domainMediator);
      _isInitialized = true;
    }
    return _versionControlComponent;
  }
}
