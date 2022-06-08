class UserSignUpRequestModel {
  String? email;
  String? password;
  String? studentNumber;
  String? nameSurname;
  String? faculty;
  String? department;

  UserSignUpRequestModel({
    this.email,
    this.password,
    this.studentNumber,
    this.nameSurname,
    this.faculty,
    this.department,
  });

  UserSignUpRequestModel.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    password = json['password'];
    studentNumber = json['studentNumber'];
    nameSurname = json['nameSurname'];
    faculty = json['faculty'];
    department = json['department'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['password'] = password;
    data['studentNumber'] = studentNumber;
    data['nameSurname'] = nameSurname;
    data['faculty'] = faculty;
    data['department'] = department;
    return data;
  }
}
