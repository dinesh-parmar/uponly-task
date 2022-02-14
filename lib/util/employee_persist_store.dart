import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

class EmployeePersistStore extends IPersistStore {
  late SharedPreferences prefs;

  @override
  Future<void> delete(String key) => prefs.remove(key);

  @override
  Future<void> deleteAll() => prefs.clear();

  @override
  Future<void> init() async => prefs = await SharedPreferences.getInstance();

  @override
  Object? read(String key) => prefs.get(key);

  @override
  Future<void> write<T>(String key, T value) {
    switch (T) {
      case String:
        return prefs.setString(key, value as String);
      case int:
        return prefs.setInt(key, value as int);
      case double:
        return prefs.setDouble(key, value as double);
      case bool:
        return prefs.setBool(key, value as bool);
      default:
        return prefs.setString(key, jsonEncode(value));
    }
  }
}
