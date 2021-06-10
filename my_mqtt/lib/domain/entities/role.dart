enum Roles {
  reader,
  adjuster,
  manufacter,
  undefined,
}

class Role {
  const Role(this.role);

  final Roles role;

  String get localizedName {
    switch (role) {
      case Roles.reader:
        return 'читатель';
      case Roles.adjuster:
        return 'наладчик';
      case Roles.manufacter:
        return 'производитель';

      //only for app. not for server.
      case Roles.undefined:
        return 'неопределено';
    }
  }
}
