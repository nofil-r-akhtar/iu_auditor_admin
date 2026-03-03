
import 'dart:convert';
import 'dart:isolate';

import 'package:http/http.dart' as http;
import 'package:iu_auditor_admin/apis/apis_end_points.dart';
import 'package:iu_auditor_admin/apis/connectivty.dart';
import 'package:iu_auditor_admin/const/enums.dart';

class ApiRequest {
  final CheckConnectivity _connectivity = CheckConnectivity();
  
  static Map<String, String> headers = {
    'Content-Type': 'application/json',
  };

  static void setAuthToken(String token) {
    headers['Authorization'] = 'Bearer $token';
  }

  Future<Map<String, dynamic>> makeRequest({
    required String url,
    required Request method,
    Map<String, String>? headers,
    dynamic params,
    bool includeAuth = true, // Add a flag for Authorization
  }) async {
    try {
      // Check internet connectivity before making the request
      bool isConnected = await _connectivity.isConnected();
      if (!isConnected) {
        throw Exception('No internet connection. Please check your network.');
      }

      // Default headers for the request
      Map<String, String> defaultHeaders = {
        'Content-Type': 'application/json',
      };

      // Uncomment if API needs authorization token
      // if (includeAuth && ApiUrls.token != null) {
      //   defaultHeaders['Authorization'] = ApiUrls.token!;
      // }

      // Merge with any custom headers
      if (headers != null) {
        defaultHeaders.addAll(headers);
      }

      // HTTP response variable
      http.Response response;

      // Handle different HTTP methods
      switch (method) {
        case Request.get:
          // Construct the URL with query parameters if params are provided
          Uri uri = params != null
              ? Uri.parse(ApisEndPoints.startUrl + url)
                  .replace(queryParameters: params)
              : Uri.parse(ApisEndPoints.startUrl + url);

          response = await http.get(
            uri,
            headers: defaultHeaders,
          );
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
      }

      // Check if the response status is OK (200)
      final responseBody = await parseJsonWithIsolate(response.body);

      // Check response status code
      if (response.statusCode == 200 || response.statusCode == 201) {
        return responseBody;
      } else if (response.statusCode == 400) {
        // Return the error message directly if status code is 400
        if (responseBody.containsKey('message')) {
          return {'error': responseBody['message']};
        } else {
          throw Exception(
              'Error: Invalid response format for status code 400.');
        }
      } else {
        // Handle other non-success status codes
        throw Exception(
            'Error: ${response.statusCode}, Response: ${response.body}');
      }
    } catch (e) {
      // Handle any errors during the request
      throw Exception('Error: $e');
    }
  }

  Future<Map<String, dynamic>> parseJsonWithIsolate(String responseBody) async {
    final receivePort = ReceivePort();

    // Spawn an isolate to parse the JSON
    await Isolate.spawn(
        _parseJsonInBackground, [responseBody, receivePort.sendPort]);

    // Wait for the result from the isolate
    return await receivePort.first;
  }

  void _parseJsonInBackground(List<dynamic> args) {
    String responseBody = args[0];
    SendPort sendPort = args[1];

    try {
      // Decode the JSON response
      final result = jsonDecode(responseBody);
      // Send the result back to the main thread
      sendPort.send(result);
    } catch (e) {
      sendPort.send({'error': e.toString()});
    }
  }
}

