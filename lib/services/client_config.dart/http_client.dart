import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:protask/main.dart';
import 'package:protask/screens/login/login.dart';
import 'package:protask/services/client_config.dart/token_handle.dart';

class HttpClient {
  static final HttpClient _instance = HttpClient._internal();
  factory HttpClient() => _instance;
  HttpClient._internal();

  final http.Client client = http.Client();
  final SharedPrefs sharedPrefs = SharedPrefs();
  static const String baseUrl = 'https://protask.shadhintech.com/api/';

  Future<http.Response> request({
    required String endpoint,
    required String method,
    Map<String, dynamic>? body,
  }) async {
    final url = Uri.parse("$baseUrl$endpoint");

    final headers = {"Content-Type": "application/json"};

    try {
      late http.Response response;
      if (method == "GET" && body != null) {
        final request = http.Request('GET', url);
        request.headers.addAll(headers);
        request.body = jsonEncode(body);
        final streamedResponse = await client.send(request);
        response = await http.Response.fromStream(streamedResponse);
      } else if (method == "POST") {
        response = await client.post(
          url,
          headers: headers,
          body: jsonEncode(body),
        );
      } else if (method == "PUT") {
        response = await client.put(
          url,
          headers: headers,
          body: jsonEncode(body),
        );
      } else if (method == "DELETE") {
        response = await client.delete(url, headers: headers);
      } else {
        throw Exception("Unsupported HTTP method: $method");
      }
      return handleResponse(response);
    } catch (e) {
      throw Exception("Failed to make request: $e");
    }
  }

  void handleTokenExpiration() async {
    await sharedPrefs.removeToken();
    navigatorKey.currentState!.pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => Login()),
      (route) => false, // Removes all previous routes
    );
  }

  http.Response handleResponse(http.Response response) {
    if (response.statusCode == 200 || response.statusCode == 201) {
      return response;
    } else {
      try {
        final responseBody = jsonDecode(response.body);
        if (responseBody is Map<String, dynamic> &&
            responseBody["error"] == "Token has expired") {
          handleTokenExpiration();
          throw Exception("Token expired. Logging out...");
        }
        throw Exception(
          "Request failed with status code ${response.statusCode}: ${response.body}",
        );
      } catch (e) {
        throw Exception(
          "Request failed with status code ${response.statusCode}. Non-JSON response received: ${response.body}",
        );
      }
    }
  }
}
