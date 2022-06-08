import 'package:flutter/material.dart';
import 'package:student/core/cache_manager.dart';

class AuthenticationManager extends CacheManager {
  BuildContext context;
  AuthenticationManager({required this.context}) {
    fetchUserLogin();
  }

  bool isLogin = false;

  Future<void> removeAllData() async {
    await removeToken();
    await removeUser();
    isLogin = false;
  }

  Future<void> fetchUserLogin() async {
    final token = await getToken();
    if (token != null) {
      isLogin = true;
    }
  }

  static of(BuildContext context) {}
}
