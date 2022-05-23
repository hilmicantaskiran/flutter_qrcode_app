import 'dart:developer';

class UserQRResponseModel {
  String? email;
  String? studentNumber;
  String? password;

  UserQRResponseModel({this.email, this.studentNumber, this.password});

  UserQRResponseModel.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    studentNumber = json['studentNumber'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['studentNumber'] = this.studentNumber;
    data['password'] = this.password;
    return data;
  }
}
