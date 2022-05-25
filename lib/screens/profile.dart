import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student/core/auth_manager.dart';
import 'package:student/screens/home.dart';
import 'package:student/assets/style/palette.dart';
import 'package:student/screens/login.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile', style: TextStyle(color: Colors.black)),
        automaticallyImplyLeading: false,
        shadowColor: Colors.white70,
        backgroundColor: Palette.whiteToDark[50],
      ),
      body: Container(
        color: Colors.white,
        width: double.infinity,
        height: double.infinity,
        alignment: Alignment.topLeft,
        child: ListView(
          children: ListTile.divideTiles(
            tiles: [
              const ListTile(
                title: Text('Information'),
                trailing: Icon(Icons.arrow_forward_ios),
              ),
              ListTile(
                title: const Text(
                  'Logout',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () {
                  context.read<AuthenticationManager>().removeAllData();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                    (route) => false,
                  );
                },
              ),
            ],
            context: context,
          ).toList(),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
        ],
        currentIndex: 1,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
                (route) => false,
              );
              break;
            case 1:
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const ProfilePage()),
                (route) => false,
              );
              break;
          }
        },
      ),
    );
  }
}
