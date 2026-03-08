/// Centralized app configuration for URLs and environment settings.
class AppConfig {
  AppConfig._();

  // ──── Backend API ────
  /// Used by mobile builds (Android emulator → host machine)
  static const String mobileApiUrl = 'http://10.0.2.2:3000';

  /// Used by iOS simulator / desktop
  static const String desktopApiUrl = 'http://localhost:3000';

  /// Web builds use empty string — requests are proxied
  /// via web_dev_config.yaml to the backend.
  static const String webApiUrl = '';

  // ──── Timeouts ────
  static const Duration connectTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 10);
}
