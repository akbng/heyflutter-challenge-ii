import 'package:shared_preferences/shared_preferences.dart';

class StorageServices {
  static Future<SharedPreferences> get _instance async =>
      _prefsInstance ??= await SharedPreferences.getInstance();
  static SharedPreferences? _prefsInstance;

  static Future<SharedPreferences?> init() async {
    _prefsInstance = await _instance;
    return _prefsInstance;
  }

  static Future<String> getString(String key) async {
    final prefs = await _instance;
    return prefs.getString(key) ?? "";
  }

  static Future<List<String>> getStringList(String key) async {
    final prefs = await _instance;
    return prefs.getStringList(key) ?? [];
  }

  static Future<int> getInt(String key) async {
    final prefs = await _instance;
    return prefs.getInt(key) ?? 0;
  }

  static Future<double> getDouble(String key) async {
    final prefs = await _instance;
    return prefs.getDouble(key) ?? 0;
  }

  static Future<void> setString({
    required String key,
    required String value,
  }) async {
    final prefs = await _instance;
    prefs.setString(key, value);
  }

  static Future<void> setStringList({
    required String key,
    required List<String> value,
  }) async {
    final prefs = await _instance;
    prefs.setStringList(key, value);
  }

  static Future<void> setInt({
    required String key,
    required int value,
  }) async {
    final prefs = await _instance;
    prefs.setInt(key, value);
  }

  static Future<void> setDouble({
    required String key,
    required double value,
  }) async {
    final prefs = await _instance;
    prefs.setDouble(key, value);
  }
}
