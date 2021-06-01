class RoutesNames {
  static const String init = '/init';
  static const beforeAuth = _BeforeAuthRoutesNames();
  static const afterAuth = _AfterAuthRoutesNames();
}

class _BeforeAuthRoutesNames {
  const _BeforeAuthRoutesNames();

  final String enter = '/enter';
  final String login = '/login';
  final String accountCreate = '/createAccount';
}

class _AfterAuthRoutesNames {
  const _AfterAuthRoutesNames();

  final String homePage = '/homePage';
}
