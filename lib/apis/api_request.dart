import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:iu_auditor_admin/apis/apis_end_points.dart';
import 'package:iu_auditor_admin/apis/connectivty.dart';
import 'package:iu_auditor_admin/const/enums.dart';
import 'package:iu_auditor_admin/services/storage_service.dart';

class ApiRequest {
  final CheckConnectivity _connectivity = CheckConnectivity();

  static Map<String, String> headers = {
    'Content-Type': 'application/json',
  };

  /// Set token in memory AND persist it to localStorage
  static Future<void> setAuthToken(String token) async {
    headers['Authorization'] = 'Bearer $token';
    await StorageService.saveToken(token);
  }

  /// Load token from localStorage into memory headers.
  /// Call this once at app startup before any API calls.
  static Future<void> loadStoredToken() async {
    final token = await StorageService.getToken();
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
  }

  /// Clear token from both memory and localStorage (on logout)
  static Future<void> clearAuthToken() async {
    headers.remove('Authorization');
    await StorageService.clearToken();
  }

  Future<Map<String, dynamic>> makeRequest({
    required String url,
    required Request method,
    Map<String, String>? headers,
    dynamic params,
    bool includeAuth = true,
  }) async {
    try {
      bool isConnected = await _connectivity.isConnected();
      if (!isConnected) {
        throw Exception('No internet connection. Please check your network.');
      }

      final Map<String, String> defaultHeaders = {
        ...ApiRequest.headers,
        if (headers != null) ...headers,
      };

      http.Response response;

      switch (method) {
        case Request.get:
          final uri = params != null
              ? Uri.parse(ApisEndPoints.startUrl + url)
                  .replace(queryParameters: params)
              : Uri.parse(ApisEndPoints.startUrl + url);
          response = await http.get(uri, headers: defaultHeaders);
          break;

        case Request.post:
          response = await http.post(
            Uri.parse(ApisEndPoints.startUrl + url),
            headers: defaultHeaders,
            body: jsonEncode(params),
          );
          break;

        case Request.put:
          response = await http.put(
            Uri.parse(ApisEndPoints.startUrl + url),
            headers: defaultHeaders,
            body: jsonEncode(params),
          );
          break;

        case Request.del:
          response = await http.delete(
            Uri.parse(ApisEndPoints.startUrl + url),
            headers: defaultHeaders,
          );
          break;

        case Request.patch:
          response = await http.patch(
            Uri.parse(ApisEndPoints.startUrl + url),
            headers: defaultHeaders,
            body: jsonEncode(params),
          );
          break;
      }

      final responseBody = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200 || response.statusCode == 201) {
        return responseBody;
      } else if (response.statusCode == 400) {
        return {'error': responseBody['message'] ?? 'Bad request'};
      } else {
        throw Exception(
            'Error: ${response.statusCode}, Response: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}