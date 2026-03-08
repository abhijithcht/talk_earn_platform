import 'package:dio/dio.dart';
import 'package:frontend/core/api/api_client.dart';
import 'package:frontend/core/api/api_endpoints.dart';
import 'package:frontend/core/api/token_storage.dart';
import 'package:frontend/features/auth/models/user.dart';

class AuthRepository {
  final Dio _dio = ApiClient.client;

  Future<void> register({
    required String email,
    required String password,
    required String fullName,
    required String gender,
    required String genderPreference,
  }) async {
    await _dio.post<dynamic>(
      ApiEndpoints.register,
      data: {
        'email': email,
        'password': password,
        'fullName': fullName,
        'gender': gender,
        'genderPreference': genderPreference,
      },
    );
  }

  Future<String> login(String email, String password) async {
    final response = await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.login,
      data: {'email': email, 'password': password},
    );

    final token = response.data!['access_token'] as String;
    await TokenStorage.saveToken(token);
    return token;
  }

  Future<void> verifyEmail(String email, String otp) async {
    await _dio.post<dynamic>(ApiEndpoints.verifyEmail, data: {'email': email, 'otpCode': otp});
  }

  Future<User> getCurrentUser() async {
    final response = await _dio.get<Map<String, dynamic>>(ApiEndpoints.profileMe);
    return User.fromJson(response.data!);
  }

  Future<void> logout() async {
    await TokenStorage.deleteToken();
  }
}
