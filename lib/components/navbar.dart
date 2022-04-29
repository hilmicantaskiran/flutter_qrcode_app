import 'package:flutter/material.dart';
import 'package:flutter_qrcode_app/assets/style/palette.dart';
import 'package:provider/provider.dart';
import 'package:flutter_qrcode_app/screens/login.dart';
import 'package:flutter_qrcode_app/core/auth_manager.dart';
import 'package:flutter_qrcode_app/model/user_model.dart';

class NavBar extends StatefulWidget {
  const NavBar({Key? key}) : super(key: key);

  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  late UserModel userModel;

  @override
  void initState() {
    super.initState();
    userModel = context.read<AuthenticationManager>().model!;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: const EdgeInsets.all(0),
        children: <Widget>[
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: Palette.greyToDark[400],
              backgroundBlendMode: BlendMode.darken,
            ),
            accountName: Text(userModel.name),
            accountEmail: Text(userModel.email),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage(userModel.imgUrl),
            ),
          ),
          ListTile(
            title: const Text('Logout'),
            onTap: () {
              context.read<AuthenticationManager>().removeAllData();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginPage(),
                ),
                (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}
