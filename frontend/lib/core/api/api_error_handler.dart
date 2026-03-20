import 'dart:convert';

import 'package:dio/dio.dart';

class ApiErrorHandler {
  static String getMessage(dynamic error) {
    if (error is DioException) {
      if (error.response?.data != null) {
        final data = error.response!.data;

        // Handle if the data is already a Map (standard JSON response)
        if (data is Map<String, dynamic>) {
          if (data.containsKey('message')) {
            final message = data['message'];
            if (message is List && message.isNotEmpty) {
              return message.first.toString();
            } else if (message is String) {
              return message;
            }
          }
        }
        // Handle if the web proxy or server returned a raw String (need to trim or parse if possible)
        else if (data is String) {
          try {
            // Try parsing if it's a JSON string
            final map = jsonDecode(data);
            if (map is Map<String, dynamic> && map.containsKey('message')) {
              final message = map['message'];
              if (message is List && message.isNotEmpty) {
                return message.first.toString();
              } else if (message is String) {
                return message;
              }
            }
          } catch (_) {
            // If jsonDecode fails, it's a plain string, return directly
            if (data.isNotEmpty) {
              return data;
            }
          }
        }
      }
      return error.message ?? 'An unexpected network error occurred.';
    }
    return error.toString();
  }
}
