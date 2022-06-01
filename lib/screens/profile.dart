import 'package:easy_localization/easy_localization.dart';
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
  String home = tr('screen.home');
  String profile = tr('screen.profile');

  @override
  Widget build(BuildContext context) {
    String locale = context.locale.toString();

    return Scaffold(
      appBar: AppBar(
        title:
            const Text('screen.profile', style: TextStyle(color: Colors.black))
                .tr(),
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
              ListTile(
                title: const Text('profile.userInfo').tr(),
                trailing: const Icon(Icons.arrow_forward_ios),
              ),
              ListTile(
                title: const Text('profile.language').tr(),
                trailing: locale == 'en_US'
                    ? const Text(
                        'English',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    : const Text(
                        'Turkish',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('profile.language').tr(),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ListTile(
                            title: const Text('English'),
                            onTap: () {
                              context.setLocale(context.supportedLocales.first);
                              Navigator.pop(context);
                            },
                          ),
                          ListTile(
                            title: const Text('Turkish'),
                            onTap: () {
                              context.setLocale(context.supportedLocales.last);
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              ListTile(
                title: const Text(
                  'profile.logout',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ).tr(),
                trailing: const Icon(Icons.arrow_forward_ios),
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
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: home,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.account_circle),
            label: profile,
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
