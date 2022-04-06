class UserModel {
  String name;
  String imgUrl;
  UserModel({required this.name, required this.imgUrl});

  factory UserModel.fake() {
    return UserModel(
        name: 'Hilmi',
        imgUrl:
            'https://images.unsplash.com/photo-1635066500129-bd51d721cb9a?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1074&q=80');
  }
}
