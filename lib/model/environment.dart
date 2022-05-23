import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  static String get fileName {
    if (kReleaseMode) {
      return '.env.production';
    } else {
      return '.env.development';
    }
  }

  static String get apiUrl {
    return dotenv.env['PUBLIC_API_URL'] ?? 'PUBLIC_API_URL not found';
  }

  static String get apiLoginPath {
    return dotenv.env['PUBLIC_API_LOGIN_PATH'] ?? 'PUBLIC_API_LOGIN_PATH not found';
  }

  static String get apiRegisterPath {
    return dotenv.env['PUBLIC_API_REGISTER_PATH'] ?? 'PUBLIC_API_REGISTER_PATH not found';
  }

  static String get apiQrPath {
    return dotenv.env['PUBLIC_API_QR_PATH'] ?? 'PUBLIC_API_QR_PATH not found';
  }
}