class UserResponseModel {
  String? token;
  Map<String, dynamic>? user;

  UserResponseModel({this.token, this.user});

  UserResponseModel.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    user = json['data']['data'];
  }

  get email => null;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['token'] = token;
    data['user'] = user;
    return data;
  }
}
