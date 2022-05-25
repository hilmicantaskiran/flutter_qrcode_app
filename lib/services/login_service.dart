import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:student/model/environment.dart';
import 'package:student/model/user_request_model.dart';
import 'package:student/model/user_response_model.dart';

abstract class ILoginService {
  final String path = Environment.apiLoginPath;

  ILoginService(this.dio);

  Future<UserResponseModel?> fetchLogin(UserRequestModel model);
  final Dio dio;
}

class LoginService extends ILoginService {
  LoginService(Dio dio) : super(dio);

  @override
  Future<UserResponseModel?> fetchLogin(UserRequestModel model) async {
    try {
      final response = await dio.post(path, data: model);
      return UserResponseModel.fromJson(
          response.data);
    } on DioError catch (e) {
      if (e.response != null) {
        if (kDebugMode) {
          log(e.response?.data);
        }
      } else {
        if (kDebugMode) {
          log(e.message);
        }
      }
      return null;
    }
  }
}
