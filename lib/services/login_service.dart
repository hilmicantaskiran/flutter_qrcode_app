import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_qrcode_app/model/environment.dart';
import 'package:flutter_qrcode_app/model/user_request_model.dart';
import 'package:flutter_qrcode_app/model/user_response_model.dart';

abstract class ILoginService {
  final String path = Environment.apiPath;

  ILoginService(this.dio);

  Future<UserResponseModel?> fetchLogin(UserRequestModel model);
  final Dio dio;
}

class LoginService extends ILoginService {
  LoginService(Dio dio) : super(dio);

  @override
  Future<UserResponseModel?> fetchLogin(UserRequestModel model) async {
    try {
      final response = await dio.post(path,data: model);
      return UserResponseModel.fromJson(response.data);
    } on DioError catch (e) {
      if (e.response != null) {
        if (kDebugMode) {
          print(e.response?.data);
        }
      } else {
        if (kDebugMode) {
          print(e.message);
        }
      }
      return null;
    }
  }
}
