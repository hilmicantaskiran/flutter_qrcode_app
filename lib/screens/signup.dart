import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_qrcode_app/screens/login.dart';
import 'package:flutter_qrcode_app/screens/qrcode.dart';
import 'package:flutter_qrcode_app/services/qr_service.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../model/user_qr_request_model.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key, required this.data}) : super(key: key);

  final String data;

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _emailController = TextEditingController();
  late final TextEditingController _studentNumberController =
      TextEditingController();
  late final TextEditingController _passwordController =
      TextEditingController();

  // ignore: todo
  // TODO: Set your IPv4 address here (192.168.38.158)
  final _serviceUrl = 'http://192.168.38.158:3000/api/v1';
  late final QRService qrService;

  @override
  void initState() {
    super.initState();
    if (widget.data != '') {
      final dio = Dio(BaseOptions(baseUrl: _serviceUrl));
      if (kDebugMode) {
        dio.interceptors.add(PrettyDioLogger());
      }
      qrService = QRService(dio);
      fetchQR(widget.data);
    }
  }

  Future<void> fetchQR(String studentID) async {
    final response = await qrService.fetchQR(UserQRRequestModel(
      studentID: studentID,
    ));
    if (response != null) {
      _emailController.text = response.email!;
      _studentNumberController.text = response.studentNumber!;
    }
  }

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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.fromLTRB(20, 0, 0, 40),
                      child: const Text(
                        'signup.signup',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 45,
                        ),
                      ).tr(),
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.fromLTRB(0, 0, 20, 40),
                      child: IconButton(
                        icon: const Icon(Icons.qr_code, size: 40),
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const QRCodePage(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: const Text(
                    'signup.email',
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
                    'signup.studentNumber',
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ).tr(),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
                  child: TextFormField(
                    controller: _studentNumberController,
                    decoration: InputDecoration(
                      hintText: '123456789',
                      hintStyle: const TextStyle(
                        fontSize: 14,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      contentPadding: const EdgeInsets.all(14),
                      suffixIcon: const Icon(Icons.numbers),
                    ),
                    obscureText: true,
                  ),
                ),
                const SizedBox(height: 18),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: const Text(
                    'signup.password',
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ).tr(),
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
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: ElevatedButton(
                    child: const Text(
                      'signup.signup',
                      style: TextStyle(
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
                        if (kDebugMode) {
                          print('Email: ${_emailController.text}');
                          print('Password: ${_passwordController.text}');
                          print(
                              'Student Number: ${_studentNumberController.text}');
                        }
                      }
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                      child: const Text(
                        'signup.alreadyHaveAccount',
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ).tr(),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                      child: TextButton(
                        child: const Text(
                          'signup.login',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ).tr(),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginPage(),
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
