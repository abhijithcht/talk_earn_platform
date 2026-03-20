import 'package:dio/dio.dart';
import 'package:frontend/core/api/api_client.dart';
import 'package:frontend/core/api/api_endpoints.dart';
import 'package:frontend/features/auth/models/user.dart';

class ProfileRepository {
  final Dio _dio = ApiClient.client;

  Future<User> getProfile() async {
    final response = await _dio.get<Map<String, dynamic>>(ApiEndpoints.profileMe);
    return User.fromJson(response.data!['data'] as Map<String, dynamic>);
  }

  Future<User> updateProfile(Map<String, dynamic> updates) async {
    final response = await _dio.put<Map<String, dynamic>>(
      ApiEndpoints.profileUpdate,
      data: updates,
    );
    return User.fromJson(response.data!['data'] as Map<String, dynamic>);
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    await _dio.post<dynamic>(
      ApiEndpoints.profileChangePassword,
      data: {'currentPassword': currentPassword, 'newPassword': newPassword},
    );
  }

  Future<void> uploadPicture(String filePath) async {
    final formData = FormData.fromMap({'file': await MultipartFile.fromFile(filePath)});
    await _dio.post<dynamic>(
      ApiEndpoints.profilePicture,
      data: formData,
      options: Options(contentType: 'multipart/form-data'),
    );
  }

  Future<void> deleteAccount(String currentPassword) async {
    await _dio.delete<dynamic>(
      ApiEndpoints.profileDeleteAccount,
      data: {'currentPassword': currentPassword},
    );
  }
}
