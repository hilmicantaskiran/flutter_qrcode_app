import 'package:flutter/material.dart';
import 'package:flutter_qrcode_app/model/user_model.dart';
import 'package:flutter_qrcode_app/core/cache_manager.dart';

class AuthenticationManager extends CacheManager {
  BuildContext context;
  AuthenticationManager({required this.context}) {
    fetchUserLogin();
  }

  bool isLogin = false;
  UserModel? model;

  Future<void> removeAllData() async {
    await removeToken();
    isLogin = false;
    model = null;
  }

  Future<void> fetchUserLogin() async {
    final token = await getToken();
    if (token != null) {
      isLogin = true;
    }
  }

  static of(BuildContext context) {}
}
