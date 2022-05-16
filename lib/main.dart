import 'package:flutter/material.dart';
import 'package:flutter_qrcode_app/assets/style/palette.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_qrcode_app/model/environment.dart';
import 'package:provider/provider.dart';
import 'package:flutter_qrcode_app/splash/splash.dart';
import 'package:flutter_qrcode_app/core/auth_manager.dart';
import 'package:easy_localization/easy_localization.dart';

Future<void> main() async {
  await dotenv.load(fileName: Environment.fileName);

  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        Provider<AuthenticationManager>(
          create: (context) => AuthenticationManager(context: context),
        ),
      ],
      child: EasyLocalization(
        supportedLocales: const [
          Locale('en', 'US'),
          Locale('tr', 'TR'),
        ],
        startLocale: const Locale('tr', 'TR'),
        path: 'lib/assets/translations',
        child: const MyApp()
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'QRCode Scanner',
      theme: ThemeData(
        primarySwatch: Palette.greyToDark,
      ),
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      home: const SplashScreen(),
    );
  }
}
