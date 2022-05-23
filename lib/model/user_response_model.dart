import 'dart:developer';

class UserResponseModel {
  String? token;

  UserResponseModel({this.token});

  UserResponseModel.fromJson(Map<String, dynamic> json) {
    token = json['data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    return data;
  }
}
