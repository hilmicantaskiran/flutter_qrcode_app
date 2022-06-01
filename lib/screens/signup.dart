import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:student/screens/home.dart';
import 'package:student/screens/login.dart';
import 'package:student/screens/qrcode.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:provider/provider.dart';
import 'package:student/core/auth_manager.dart';
import 'package:student/model/user_model.dart';
import 'package:student/model/user_signup_request_model.dart';
import 'package:student/services/signup_service.dart';
import 'package:student/core/cache_manager.dart';
import 'package:student/model/environment.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key, required this.data}) : super(key: key);

  final String data;

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> with CacheManager {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _emailController = TextEditingController();
  late final TextEditingController _studentNumberController =
      TextEditingController();
  late final TextEditingController _passwordController =
      TextEditingController();

  final _baseUrl = Environment.apiUrl;
  final _qrApiUrl = Environment.qrApiUrl;
  final _qrApiPath = Environment.qrApiPath;
  final _qrApiUsername = Environment.qrApiUsername;
  final _qrApiPassword = Environment.qrApiPassword;

  late final SignUpService signUpService;

  @override
  void initState() {
    super.initState();
    final dio = Dio(BaseOptions(baseUrl: _baseUrl));

    signUpService = SignUpService(dio);

    if (kDebugMode) {
      dio.interceptors.add(PrettyDioLogger());
    }

    if (widget.data != '') {
      fetchQR(widget.data);
    }
  }

  Future<void> fetchQR(String data) async {
    try {
      var kullaniciAdi = _qrApiUsername;
      var sifre = _qrApiPassword;
      var xml = '''
        <soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:adu="www.adu.edu.tr">
          <soap:Header/>
          <soap:Body>
              <adu:KimlikKartGetir>
                <adu:KareKod>${data.toString()}</adu:KareKod>
                <adu:KullaniciAdi>$kullaniciAdi</adu:KullaniciAdi>
                <adu:Sifre>$sifre</adu:Sifre>
              </adu:KimlikKartGetir>
          </soap:Body>
        </soap:Envelope>
      ''';

      final client = http.Client();
      final request = http.Request(
        'POST',
        Uri.parse('$_qrApiUrl$_qrApiPath'),
      );
      request.headers.addAll({'content-type': 'text/xml'});
      request.body = xml.toString();

      final streamedResponse = await client.send(request);
      final responseBody =
          await streamedResponse.stream.transform(utf8.decoder).join();
      client.close();

      final document = XmlDocument.parse(responseBody.toString());
      final result = {
        'TcKimlikNo': document.findAllElements('TcKimlikNo').first.text,
        'OgrenciSicilNo': document.findAllElements('OgrenciSicilNo').first.text,
        'Ad': document.findAllElements('Ad').first.text,
        'Soyad': document.findAllElements('Soyad').first.text,
        'BirimAd': document.findAllElements('BirimAd').first.text,
        'BolumAd': document.findAllElements('BolumAd').first.text,
        'id_OgrenciDurumTur':
            document.findAllElements('id_OgrenciDurumTur').first.text,
        'OgrenciDurumTurAd':
            document.findAllElements('OgrenciDurumTurAd').first.text,
      };

      setState(() {
        _emailController.text = '${result['OgrenciSicilNo']}@stu.adu.edu.tr';
        _studentNumberController.text = '${result['OgrenciSicilNo']}';
        _passwordController.text = '${result['TcKimlikNo']}';
      });

      /*
      fetchUserSignUp(
        _emailController.text,
        _studentNumberController.text,
        _passwordController.text,
      );
      */
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('QR Code Error'),
          content: const Text('Please try again'),
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

  Future<void> fetchUserSignUp(
    String email,
    String studentNumber,
    String password,
  ) async {
    final response = await signUpService.fetchSignup(
      UserSignUpRequestModel(
        email: email.replaceAll(' ', ''),
        studentNumber: studentNumber.replaceAll(' ', ''),
        password: password,
      ),
    );
    if (response != null) {
      saveToken(response.token ?? '');
      navigateToHome();
      context.read<AuthenticationManager>().model = UserModel.fake();
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
                          fetchUserSignUp(
                            _emailController.text,
                            _studentNumberController.text,
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
                        padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                        child: const Text(
                          'signup.alreadyHaveAccount',
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
                            'signup.login',
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
      ),
    );
  }
}
