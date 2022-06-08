import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class CacheManager {
  Future<bool> saveToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(CacheManagerKey.TOKEN.toString(), token);
    return true;
  }

  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(CacheManagerKey.TOKEN.toString());
  }

  Future<bool> removeToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    return true;
  }

  Future<bool> saveUser(Map<String, dynamic> user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(CacheManagerKey.USER.toString(), json.encode(user));
    return true;
  }

  Future<String?> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? user = prefs.getString(CacheManagerKey.USER.toString());
    if (user == null) {
      return null;
    }
    return user;
  }

  Future<bool> removeUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(CacheManagerKey.USER.toString());
    return true;
  }
}

// ignore: constant_identifier_names
enum CacheManagerKey { TOKEN, USER }
