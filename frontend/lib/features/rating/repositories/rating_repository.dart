import 'package:dio/dio.dart';
import 'package:frontend/core/api/api_client.dart';
import 'package:frontend/core/api/api_endpoints.dart';

class RatingRepository {
  final Dio _dio = ApiClient.client;

  Future<void> submitRating({
    required int ratedUserId,
    required int score,
  }) async {
    await _dio.post<dynamic>(
      ApiEndpoints.ratingSubmit,
      data: {
        'ratedUserId': ratedUserId,
        'score': score,
      },
    );
  }
}
