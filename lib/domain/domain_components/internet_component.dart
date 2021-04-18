import 'package:my_mqtt/data/enums.dart';
import 'package:my_mqtt/domain/domain_component.dart';
import 'package:my_mqtt/domain/domain_mediator.dart';

class InternetComponent extends DomainComponent {
  static late final InternetComponent _internetComponent;
  static bool _isInitialized = false;
  bool get isInitialized => _isInitialized;
  InternetComponent._(DomainMediator domainMediator) : super(domainMediator);
  factory InternetComponent(DomainMediator domainMediator) {
    if (_isInitialized == false) {
      _internetComponent = InternetComponent._(domainMediator);
      _isInitialized = true;
    }
    return _internetComponent;
  }

  InternetStatuses _internetStatus = InternetStatuses.notChecked;
  InternetStatuses get internetStatus => _internetStatus;
  set internetStatus(InternetStatuses internetStatus) {
    _internetStatus = internetStatus;
    notifyListeners();
  }
}
