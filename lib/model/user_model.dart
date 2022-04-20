class UserModel {
  String name;
  String imgUrl;
  String email;

  UserModel({required this.name, required this.imgUrl, required this.email});

  factory UserModel.fake() {
    return UserModel(
        name: 'Hilmi',
        imgUrl: 'https://avatars.githubusercontent.com/u/48391866?v=4',
        email: 'hilmicantaskiran@outlook.com');
  }
}
