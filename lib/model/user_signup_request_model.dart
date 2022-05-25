class UserSignUpRequestModel {
  String? email;
  String? password;
  String? studentNumber;

  UserSignUpRequestModel({this.email, this.password, this.studentNumber});

  UserSignUpRequestModel.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    password = json['password'];
    studentNumber = json['studentNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['password'] = password;
    data['studentNumber'] = studentNumber;
    return data;
  }
}

