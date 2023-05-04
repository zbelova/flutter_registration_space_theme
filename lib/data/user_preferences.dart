import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'classes.dart';

class UserPreferences {
  //создание переменной для сохранения preferences
  static SharedPreferences? _preferences;

  //ключ для текстового поля
  final _keyUsername = 'username';
  final _keyPassword = 'userpassword';
  final _keyLoggedIn = 'loggedIn';
  final bool _loggedInDefault = false;
  final _keyUserObject  = 'userObject';
  final _keyRememberLoggedIn = 'rememberLoggedIn';

  //инициализация preferences
  Future init() async => _preferences = await SharedPreferences.getInstance();

  //функция очистки сохраненных данных пользователя - вызывать если надо сбросить данные
  Future clear() async => _preferences?.clear();

  // задаем значение username нашему ключу
  Future setUsername(String username) async =>
      await _preferences?.setString(_keyUsername, username);

  Future setPassword(String userpassword) async =>
      await _preferences?.setString(_keyPassword, userpassword);

  //читаем username
  String? getUsername() => _preferences?.getString(_keyUsername);

  String? getUserpassword() => _preferences?.getString(_keyPassword);

  // удаляем username
  Future<bool>? deleteUsername() => _preferences?.remove(_keyUsername);

  Future<bool>? deleteUserpassword() => _preferences?.remove(_keyPassword);

  //сохраняем флажок, что пользователь авторизован
  Future setLoggedIn(bool complete) async =>
      await _preferences?.setBool(_keyLoggedIn, complete);

  bool getLoggedIn() =>
      _preferences?.getBool(_keyLoggedIn) ??
          _loggedInDefault;

  Future setRememberLoggedIn(bool flag) async =>
    await _preferences?.setBool(_keyRememberLoggedIn, flag);

  bool getRememberLoggedIn() =>
      _preferences?.getBool(_keyRememberLoggedIn) ??
          false;

  //сохранение объекта юзера в виде json
  Future setUserObject(User user) async {
    Map<String, dynamic> userJson = user.toJson();
    await _preferences?.setString(_keyUserObject, jsonEncode(userJson));
  }

  //получение объекта юзера из сохраненного json
  User? getUserObject() {
    String? userJson = _preferences?.getString(_keyUserObject);
    if (userJson != null) {
      User fromJson =User.fromJson(jsonDecode(userJson));
      return fromJson;
    }
    return User(name: '');
  }
}
