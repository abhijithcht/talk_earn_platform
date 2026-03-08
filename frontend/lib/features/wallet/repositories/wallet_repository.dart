import 'package:dio/dio.dart';
import 'package:frontend/core/api/api_client.dart';
import 'package:frontend/core/api/api_endpoints.dart';

class WalletRepository {
  final Dio _dio = ApiClient.client;

  Future<int> getBalance() async {
    final response = await _dio.get<Map<String, dynamic>>(ApiEndpoints.walletBalance);
    return response.data!['balance'] as int;
  }

  Future<void> withdraw(int amount, String method, String details) async {
    await _dio.post<dynamic>(
      ApiEndpoints.walletWithdraw,
      data: {'amount': amount, 'method': method, 'details': details},
    );
  }
}
