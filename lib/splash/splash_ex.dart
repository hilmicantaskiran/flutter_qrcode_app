import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:student/assets/style/palette.dart';
import 'package:student/screens/login.dart';
import 'package:student/screens/signup.dart';

class SplashExScreen extends StatefulWidget {
  const SplashExScreen({Key? key}) : super(key: key);

  @override
  _SplashExScreenState createState() => _SplashExScreenState();
}

class _SplashExScreenState extends State<SplashExScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: Column(
            children: <Widget>[
              Container(
                alignment: Alignment.centerRight,
                margin: const EdgeInsets.fromLTRB(0, 10, 10, 0),
                child: PopupMenuButton(
                  itemBuilder: (context) => const [
                    PopupMenuItem(
                      value: 'en',
                      child: Text(
                        'English',
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ),
                    PopupMenuItem(
                      value: 'tr',
                      child: Text(
                        'Türkçe',
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                  onSelected: (value) {
                    if (value == 'en') {
                      context.setLocale(context.supportedLocales.first);
                    } else if (value == 'tr') {
                      context.setLocale(context.supportedLocales.last);
                    }
                  },
                  icon: const Icon(
                    Icons.language,
                    color: Colors.black,
                  ),
                  iconSize: 30,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: const BorderSide(
                      color: Colors.grey,
                      width: 1,
                    ),
                  ),
                  elevation: 0,
                ),
              ),
              Flexible(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      'lib/assets/images/adu_logo.png',
                      width: 200,
                      height: 200,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'splash.appName',
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.black,
                      ),
                    ).tr(),
                  ],
                ),
              ),
              Column(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                        primary: Palette.blueToDark,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'screen.login',
                        style: TextStyle(color: Colors.white),
                      ).tr(),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                        primary: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'screen.signup',
                        style: TextStyle(color: Colors.white),
                      ).tr(),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const SignUpPage(data: ''),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
