class Config {
  late final bool passwordIsTrue;
  late final bool outerDeviceIsOnline;

  Config({required this.outerDeviceIsOnline, required this.passwordIsTrue});

  Config.fromJson(Map<String, dynamic> json) {
    this.outerDeviceIsOnline = json["outerDeviceIsOnline"];
    this.passwordIsTrue = json["passwordIsTrue"];
  }
}
