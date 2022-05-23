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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['password'] = this.password;
    data['studentNumber'] = this.studentNumber;
    return data;
  }
}

