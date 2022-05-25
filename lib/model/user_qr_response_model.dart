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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['studentNumber'] = studentNumber;
    data['password'] = password;
    return data;
  }
}
