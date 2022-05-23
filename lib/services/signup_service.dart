import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_qrcode_app/model/environment.dart';
import 'package:flutter_qrcode_app/model/user_signup_request_model.dart';
import 'package:flutter_qrcode_app/model/user_response_model.dart';

abstract class ISignupService {
  final String path = Environment.apiRegisterPath;

  ISignupService(this.dio);

  Future<UserResponseModel?> fetchSignup(UserSignUpRequestModel model);
  final Dio dio;
}

class SignUpService extends ISignupService {
  SignUpService(Dio dio) : super(dio);

  @override
  Future<UserResponseModel?> fetchSignup(UserSignUpRequestModel model) async {
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
