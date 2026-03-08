import 'package:dio/dio.dart';
import 'package:frontend/core/api/api_client.dart';
import 'package:frontend/core/api/api_endpoints.dart';
import 'package:frontend/features/auth/models/user.dart';

class ProfileRepository {
  final Dio _dio = ApiClient.client;

  Future<User> getProfile() async {
    final response = await _dio.get<Map<String, dynamic>>(ApiEndpoints.profileMe);
    return User.fromJson(response.data!);
  }

  Future<User> updateProfile(Map<String, dynamic> updates) async {
    final response = await _dio.put<Map<String, dynamic>>(
      ApiEndpoints.profileUpdate,
      data: updates,
    );
    return User.fromJson(response.data!);
  }
}
