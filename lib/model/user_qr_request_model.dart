class UserQRRequestModel {
  String? studentID;

  UserQRRequestModel({this.studentID});

  UserQRRequestModel.fromJson(Map<String, dynamic> json) {
    studentID = json['studentID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['studentID'] = studentID;
    return data;
  }
}