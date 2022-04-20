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

  static String get apiPath {
    return dotenv.env['PUBLIC_API_PATH'] ?? 'PUBLIC_API_PATH not found';
  }
}