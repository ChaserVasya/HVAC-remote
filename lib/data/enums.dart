enum PasswordPageStates {
  notCheckedPasswordState,
  passwordCheckingState,
  wrongPasswordState,
  truePasswordState,
}

enum DataflowStatuses {
  streaming,
  setting,
  notSetted,
  disposing,
}

enum InternetStatuses {
  notChecked,
  checking,
  good,
  bad,
}

enum AuthStatuses {
  wrongPassword,
  passwordNotChecked,
  passwordChecking,
  truePassword,
}

enum ServerConnectionStatuses {
  notChecked,
  checking,
  good,
  bad,
}

enum DomainEvents {
  test,
  badConnection,
}

enum Senders {
  serverConnectionComponent,
  authComponent,
  internetComponent,
  versionControlComponent,
  dataflowComponent,
}

enum Endpoints {
  authentication,
  events,
  config,
  test,
  commands,
}
