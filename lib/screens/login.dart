import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_qrcode_app/model/environment.dart';
import 'package:flutter_qrcode_app/model/user_model.dart';
import 'package:flutter_qrcode_app/screens/home.dart';
import 'package:flutter_qrcode_app/core/auth_manager.dart';
import 'package:flutter_qrcode_app/core/cache_manager.dart';
import 'package:flutter_qrcode_app/services/login_service.dart';
import 'package:flutter_qrcode_app/model/user_request_model.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with CacheManager {
  final _formKey = GlobalKey<FormState>();

  late final LoginService loginService;
  final _baseUrl = Environment.apiUrl;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.fromLTRB(20, 0, 0, 40),
                  child: const Text(
                    'Login',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 45,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: const Text(
                    'Email address',
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 5, 20, 10),
                  child: TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      hintText: 'example@email.com',
                      hintStyle: const TextStyle(
                        fontSize: 14,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      contentPadding: const EdgeInsets.all(14),
                      suffixIcon: const Icon(
                        Icons.mail_outline_rounded,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: const Text(
                    'Password',
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
                  child: TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      hintText: '••••••••',
                      hintStyle: const TextStyle(
                        fontSize: 14,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      contentPadding: const EdgeInsets.all(14),
                      suffixIcon: const Icon(
                        Icons.lock_outline_rounded,
                      ),
                    ),
                    obscureText: true,
                  ),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: RichText(
                    text: const TextSpan(
                      text: 'Forgot password?',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: ElevatedButton(
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                      primary: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        _formKey.currentState!.save();
                        fetchUserLogin(
                          _emailController.text,
                          _passwordController.text,
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    final dio = Dio(BaseOptions(baseUrl: _baseUrl));
    if (kDebugMode) {
      dio.interceptors.add(PrettyDioLogger());
    }
    loginService = LoginService(dio);
  }

  Future<void> fetchUserLogin(String email, String password) async {
    final response = await loginService.fetchLogin(
      UserRequestModel(
        email: email,
        password: password,
      ),
    );

    if (response != null) {
      saveToken(response.token ?? '');
      navigateToHome();
      context.read<AuthenticationManager>().model = UserModel.fake();
    } else {
      _emailController.clear();
      _passwordController.clear();
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Login failed'),
          content: const Text('Please check your email and password'),
          actions: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.black,
              ),
              child: const Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
    }
  }

  void navigateToHome() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const HomePage(),
      ),
    );
  }
}
