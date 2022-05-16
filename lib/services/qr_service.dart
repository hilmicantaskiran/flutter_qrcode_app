import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_qrcode_app/model/user_qr_request_model.dart';
import 'package:flutter_qrcode_app/model/user_qr_response_model.dart';

abstract class IQRService {
  IQRService(this.dio);

  Future<UserQRResponseModel?> fetchQR(UserQRRequestModel model);
  final Dio dio;
}

class QRService extends IQRService {
  QRService(Dio dio) : super(dio);

  @override
  Future<UserQRResponseModel?> fetchQR(UserQRRequestModel model) async {
    try {
      final response =
          await dio.get('/student', queryParameters: model.toJson());

      // ignore: fixme
      // FIXME: Response is coming null
      if (kDebugMode) {
        if (response.data != null) {
          print('Response: ${response.data}');
          print('Response Model: ${UserQRResponseModel.fromJson(response.data)}');
        } else { print('Response: null'); }
      }
      return UserQRResponseModel.fromJson(response.data);
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
