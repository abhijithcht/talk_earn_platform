import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Centralized app configuration for URLs and environment settings.
class AppConfig {
  AppConfig._();

  // ──── Backend API ────
  /// Used by mobile builds (Android emulator → host machine)
  static String get mobileApiUrl => dotenv.env['MOBILE_API_URL'] ?? 'http://10.0.2.2:3000';

  /// Used by iOS simulator / desktop
  static String get desktopApiUrl => dotenv.env['DESKTOP_API_URL'] ?? 'http://localhost:3000';

  /// Web builds use empty string — requests are proxied
  /// via web_dev_config.yaml to the backend.
  static String get webApiUrl => dotenv.env['WEB_API_URL'] ?? '';

  // ──── Timeouts ────
  static const Duration connectTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 10);
  // TODO: Add global API refresh token endpoint/configuration if supported by backend
}
