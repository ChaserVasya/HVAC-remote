import 'package:my_mqtt/application/service_locator.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum PrefsKeys {
  passwordIsTrue,
  userJson,
}

class PrefsDao {
  final SharedPreferences _prefs = sl<SharedPreferences>();

  bool contains(PrefsKeys key) => _prefs.containsKey(_keys[key]!);

  Future<bool> setBool(PrefsKeys key, bool value) => _prefs.setBool(_keys[key]!, value);
  Future<bool> setInt(PrefsKeys key, int value) => _prefs.setInt(_keys[key]!, value);
  Future<bool> setDouble(PrefsKeys key, double value) => _prefs.setDouble(_keys[key]!, value);
  Future<bool> setString(PrefsKeys key, String value) => _prefs.setString(_keys[key]!, value);
  Future<bool> setStringList(PrefsKeys key, List<String> value) => _prefs.setStringList(_keys[key]!, value);

  bool? getBool(PrefsKeys key) => _prefs.getBool(_keys[key]!);
  int? getInt(PrefsKeys key) => _prefs.getInt(_keys[key]!);
  double? getDouble(PrefsKeys key) => _prefs.getDouble(_keys[key]!);
  String? getString(PrefsKeys key) => _prefs.getString(_keys[key]!);
  List<String>? getStringList(PrefsKeys key) => _prefs.getStringList(_keys[key]!);

  Future<bool> remove(PrefsKeys key) => _prefs.remove(_keys[key]!);
}
//for avoiding small typos and dyplicates

Map<PrefsKeys, String> _keys = {for (var key in PrefsKeys.values) key: key.toString().split(".").last};
