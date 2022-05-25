import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student/core/auth_manager.dart';
import 'package:student/model/user_model.dart';
import 'package:student/screens/home.dart';
import 'package:student/screens/login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<void> controlToApp() async {
    await readAuthManager.fetchUserLogin();
    if (readAuthManager.isLogin) {
      await Future.delayed(const Duration(seconds: 1));
      readAuthManager.model = UserModel.fake();
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const HomePage(),
        ),
        (route) => false,
      );
    } else {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const LoginPage(),
        ),
        (route) => false,
      );
    }
  }

  AuthenticationManager get readAuthManager =>
      context.read<AuthenticationManager>();

  @override
  void initState() {
    super.initState();
    controlToApp();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
