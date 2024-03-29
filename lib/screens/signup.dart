import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:student/model/dropdown_items.dart';
import 'package:student/screens/home.dart';
import 'package:student/screens/qrcode.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:student/model/user_signup_request_model.dart';
import 'package:student/services/signup_service.dart';
import 'package:student/core/cache_manager.dart';
import 'package:student/model/environment.dart';
import 'package:http/http.dart' as http;
import 'package:student/splash/splash_ex.dart';
import 'package:xml/xml.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key, required this.data}) : super(key: key);

  final String data;

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> with CacheManager {
  final _formKey = GlobalKey<FormState>();

  late bool _passwordVisible = true;

  late final TextEditingController _emailController = TextEditingController();
  late final TextEditingController _studentNumberController =
      TextEditingController();
  late final TextEditingController _passwordController =
      TextEditingController();
  late final TextEditingController _nameSurnameController =
      TextEditingController();
  late final TextEditingController _facultyController = TextEditingController();
  late final TextEditingController _departmentController =
      TextEditingController();

  final _baseUrl = Environment.apiUrl;
  final _qrApiUrl = Environment.qrApiUrl;
  final _qrApiPath = Environment.qrApiPath;
  final _qrApiUsername = Environment.qrApiUsername;
  final _qrApiPassword = Environment.qrApiPassword;

  late final SignUpService signUpService;

  String? _selectedFaculty;
  String? _selectedDepartment;

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
    } else {
      Future(() {
        final snackBar = SnackBar(
          content: const Text(
            'signup.qrCodeMessage',
            style: TextStyle(
              fontSize: 14,
            ),
          ).tr(),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          duration: const Duration(seconds: 3),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      });
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
        _nameSurnameController.text = '${result['Ad']} ${result['Soyad']}';
        _facultyController.text = '${result['BirimAd']}';
        _departmentController.text = '${result['BolumAd']}';

        _selectedFaculty = '${result['BirimAd']}';
        _selectedDepartment = '${result['BolumAd']}';
      });
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
    String nameSurname,
    String faculty,
    String department,
  ) async {
    final response = await signUpService.fetchSignup(
      UserSignUpRequestModel(
        email: email.replaceAll(' ', ''),
        studentNumber: studentNumber.replaceAll(' ', ''),
        password: password,
        nameSurname: nameSurname,
        faculty: faculty,
        department: department,
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
      appBar: AppBar(
        title: const Text(
          'signup.signup',
          style: TextStyle(
            color: Colors.black,
          ),
        ).tr(),
        backgroundColor: Colors.white,
        shadowColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.qr_code, size: 30),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const QRCodePage(),
              ),
            ),
          ),
        ],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 30),
          onPressed: () => Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const SplashExScreen(),
            ),
            (route) => false,
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: ListView(
              children: <Widget>[
                const SizedBox(height: 20),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: const Text(
                    'signup.nameSurname',
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ).tr(),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.fromLTRB(20, 5, 20, 10),
                  child: TextFormField(
                    controller: _nameSurnameController,
                    decoration: InputDecoration(
                      hintText: 'Hilmi Can Taşkıran',
                      hintStyle: const TextStyle(
                        fontSize: 14,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      contentPadding: const EdgeInsets.all(14),
                      suffixIcon: const Icon(
                        Icons.account_circle_outlined,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
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
                    'signup.faculty',
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ).tr(),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 5, 20, 10),
                  child: DropdownButtonFormField(
                    menuMaxHeight: 400,
                    items: DropdownItems.facultylist,
                    value: _selectedFaculty,
                    hint: const Text(
                      'Fakülte Seçiniz',
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _facultyController.text = value.toString();
                        _selectedFaculty = value.toString();
                      });
                    },
                    icon: const Icon(
                      Icons.school_outlined,
                      color: Colors.grey,
                    ),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      contentPadding: const EdgeInsets.all(14),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: const Text(
                    'signup.department',
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ).tr(),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 5, 20, 10),
                  child: DropdownButtonFormField(
                    menuMaxHeight: 400,
                    items: DropdownItems.departmentlist,
                    value: _selectedDepartment,
                    hint: const Text(
                      'Bölüm Seçiniz',
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _departmentController.text = value.toString();
                        _selectedDepartment = value.toString();
                      });
                    },
                    icon: const Icon(
                      Icons.book_outlined,
                      color: Colors.grey,
                    ),
                    isExpanded: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      contentPadding: const EdgeInsets.all(14),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
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
                  padding: const EdgeInsets.all(20),
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
                          _nameSurnameController.text,
                          _facultyController.text,
                          _departmentController.text,
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
}
