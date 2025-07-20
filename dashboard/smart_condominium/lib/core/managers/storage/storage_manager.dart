import 'package:shared_preferences/shared_preferences.dart';

class StorageManager {
  StorageManager._();
  static final instance = StorageManager._();
  static late SharedPreferences _sharedPreferences;

  Future<void> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  Future<String?> getStr(String key) async {
    final value = _sharedPreferences.getString(key);
    return value;
  }

  Future<bool?> getBool(String key) async {
    final value = _sharedPreferences.getBool(key);
    return value;
  }

  Future<double?> getDouble(String key) async {
    final value = _sharedPreferences.getDouble(key);
    return value;
  }

  Future<int?> getInt(String key) async {
    final value = _sharedPreferences.getInt(key);
    return value;
  }

  Future<bool> clear() async {
    final success = await _sharedPreferences.clear();
    return success;
  }

  Future<bool> setString(String key, String value) async {
    final response = await _sharedPreferences.setString(key, value);
    return response;
  }

  Future<bool> setBool(String key, bool value) async {
    final response = await _sharedPreferences.setBool(key, value);
    return response;
  }

  Future<bool> setDouble(String key, double value) async {
    final response = await _sharedPreferences.setDouble(key, value);
    return response;
  }

  Future<bool?> remove(String key) async {
    bool? response;
    response = await _sharedPreferences.remove(key);
    return response;
  }

  Future<bool> setInt(String key, int value) async {
    final response = await _sharedPreferences.setInt(key, value);
    return response;
  }

  Future<bool> setNum(String key, num value) async {
    late bool response;
    if (value is int) {
      response = await setInt(key, value.toInt());
    }
    if (value is double) {
      response = await setDouble(key, value.toDouble());
    }
    return response;
  }
}
