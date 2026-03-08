import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:frontend/core/api/token_storage.dart';
import 'package:frontend/core/config/app_config.dart';

class ApiClient {
  static String get baseUrl {
    if (kIsWeb) return AppConfig.webApiUrl;
    return AppConfig.desktopApiUrl;
  }

  // Lazy singleton — created once, reused everywhere
  static final Dio _instance = _createDio();

  static Dio get client => _instance;

  static Dio _createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: AppConfig.connectTimeout,
        receiveTimeout: AppConfig.receiveTimeout,
        headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
      ),
    );

    // Request Interceptor: Attach JWT token
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await TokenStorage.getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (e, handler) async {
          if (e.response?.statusCode == 401) {
            await TokenStorage.deleteToken();
          }
          return handler.next(e);
        },
      ),
    );

    return dio;
  }
}
