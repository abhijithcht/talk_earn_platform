import 'package:dio/dio.dart';
import 'package:frontend/core/api/api_client.dart';
import 'package:frontend/core/api/api_endpoints.dart';

class MatchRepository {
  final Dio _dio = ApiClient.client;

  Future<Map<String, dynamic>> findMatch(String medium) async {
    final response = await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.matchFind,
      data: {'medium': medium},
    );
    // TODO: Implement WebRTC signaling or Chat socket connection once match is found
    // Ref: lib/features/chat/
    return response.data!['data'] as Map<String, dynamic>;
  }

  Future<void> cancelMatch() async {
    await _dio.post<dynamic>(ApiEndpoints.matchCancel);
  }
}
