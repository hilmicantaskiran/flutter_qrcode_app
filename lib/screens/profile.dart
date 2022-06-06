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
  @override
  Widget build(BuildContext context) {
    late String locale = context.locale.toString();

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        alignment: Alignment.topLeft,
        color: Colors.white,
        child: ListView(
          children: ListTile.divideTiles(
            color: const Color.fromARGB(255, 196, 196, 196),
            tiles: [
              ListTile(
                leading: const Icon(
                  Icons.person,
                  color: Palette.greyToDark,
                ),
                title: const Text('profile.userInfo').tr(),
              ),
              ListTile(
                leading: const Icon(
                  Icons.language,
                  color: Palette.greyToDark,
                ),
                title: const Text('profile.language').tr(),
                trailing: locale == 'en_US'
                    ? const Text(
                        'profile.languages.en',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ).tr()
                    : const Text(
                        'profile.languages.tr',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ).tr(),
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) => Container(
                      height: MediaQuery.of(context).size.height * 0.15,
                      color: Colors.white,
                      child: ListView(
                        children: <Widget>[
                          ListTile(
                            title: Text(
                              'English',
                              style: locale == 'en_US'
                                  ? const TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.w500,
                                    )
                                  : const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                    ),
                            ),
                            onTap: () {
                              context.setLocale(context.supportedLocales.first);
                              Navigator.pop(context);
                            },
                          ),
                          ListTile(
                            title: Text(
                              'Türkçe',
                              style: locale == 'tr_TR'
                                  ? const TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.w500,
                                    )
                                  : const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                    ),
                            ),
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
                leading: const Icon(
                  Icons.exit_to_app,
                  color: Palette.greyToDark,
                ),
                title: const Text(
                  'profile.logout',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ).tr(),
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
            label: tr('screen.home'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.account_circle),
            label: tr('screen.profile'),
          ),
        ],
        currentIndex: 1,
        selectedItemColor: Palette.blueToDark[50],
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
        unselectedItemColor: Palette.whiteToDark[600],
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
