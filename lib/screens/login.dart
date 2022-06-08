import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:student/model/environment.dart';
import 'package:student/screens/home.dart';
import 'package:student/core/cache_manager.dart';
import 'package:student/services/login_service.dart';
import 'package:student/model/user_request_model.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:student/screens/signup.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with CacheManager {
  final _formKey = GlobalKey<FormState>();

  late final LoginService loginService;
  final _baseUrl = Environment.apiUrl;

  late bool _passwordVisible = true;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
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
                      'login.login',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 45,
                      ),
                    ).tr(),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Text(
                      'login.email',
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ).tr(),
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
                      'login.password',
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ).tr(),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
                    child: TextFormField(
                      controller: _passwordController,
                      obscureText: _passwordVisible,
                      decoration: InputDecoration(
                        hintText: '••••••••',
                        hintStyle: const TextStyle(
                          fontSize: 14,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        contentPadding: const EdgeInsets.all(14),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _passwordVisible
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _passwordVisible = !_passwordVisible;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                    child: const Text(
                      'login.forgot',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ).tr(),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                    child: ElevatedButton(
                      child: const Text(
                        'login.login',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ).tr(),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                        child: const Text(
                          'login.dontHaveAccount',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                          ),
                        ).tr(),
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                        child: TextButton(
                          child: const Text(
                            'login.signup',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ).tr(),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const SignUpPage(data: ''),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  Container(
                    alignment: Alignment.bottomCenter,
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
                      ),
                      iconSize: 30,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  )
                ],
              ),
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
        email: email.replaceAll(' ', ''),
        password: password,
      ),
    );

    if (response != null) {
      saveToken(response.token ?? '');
      saveUser(Map<String, dynamic>.from({
        "nameSurname": response.user!['nameSurname'],
        "faculty": response.user!['faculty'],
        "department": response.user!['department'],
        "studentNumber": response.user!['studentNumber'],
        "email": response.user!['email'],
      }));
      navigateToHome();
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
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => const HomePage(),
      ),
      (route) => false,
    );
  }
}
