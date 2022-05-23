import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_qrcode_app/model/user_qr_request_model.dart';
import 'package:flutter_qrcode_app/model/user_qr_response_model.dart';

import '../model/environment.dart';

abstract class IQRService {
  final String path = Environment.apiQrPath;

  IQRService(this.dio);

  Future<UserQRResponseModel?> fetchQR(UserQRRequestModel model);
  final Dio dio;
}

class QRService extends IQRService {
  QRService(Dio dio) : super(dio);

  @override
  Future<UserQRResponseModel?> fetchQR(UserQRRequestModel model) async {
    try {
      final response = await dio.get(path,
        queryParameters: model.toJson(),
      );
      return UserQRResponseModel.fromJson(response.data['data'].first);
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
