class UserQRRequestModel {
  String? studentID;

  UserQRRequestModel({this.studentID});

  UserQRRequestModel.fromJson(Map<String, dynamic> json) {
    studentID = json['studentID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['studentID'] = this.studentID;
    return data;
  }
}