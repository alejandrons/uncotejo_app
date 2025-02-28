import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../utils/auth_service.dart';
import '../exceptions/exception_advisor.dart';

class HttpClient {
  static final String _defaultBaseUrl = dotenv.env['BASE_URL'] ?? "";
  static final String baseUrl = _defaultBaseUrl.isNotEmpty
      ? _defaultBaseUrl
      : throw Exception("BASE_URL no definida en .env");

  static Future<dynamic> get(String endpoint) async {
    print('$baseUrl$endpoint');
    String? token = await AuthService.getToken();
    final response = await http.get(
      Uri.parse('$baseUrl$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );
    final processedResponse = jsonDecode(response.body);
    // print(processedResponse);
    return processedResponse;
    // print(response.body);
  }

  static Future<dynamic> post(
      String endpoint, Map<String, dynamic> body) async {
    String? token = await AuthService.getToken();
    final response = await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode(body),
    );
    final resp = processResponse(response);
    return resp;
  }

  static Future<dynamic> put(String endpoint, Map<String, dynamic> body) async {
    String? token = await AuthService.getToken();
    final response = await http.put(
      Uri.parse('$baseUrl$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode(body),
    );
    return processResponse(response);
  }

  static Future<dynamic> delete(String endpoint) async {
    String? token = await AuthService.getToken();
    final response = await http.delete(
      Uri.parse('$baseUrl$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );
    return processResponse(response);
  }
}
