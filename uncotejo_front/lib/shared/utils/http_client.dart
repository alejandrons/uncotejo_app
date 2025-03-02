import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'token_service.dart';

class HttpClient {
  static final String _defaultBaseUrl = dotenv.env['BASE_URL'] ?? "";
  static final String baseUrl = _defaultBaseUrl.isNotEmpty
      ? _defaultBaseUrl
      : throw Exception("BASE_URL no definida en .env");

  static Future<dynamic> get(String endpoint) async {
    String? token = await TokenService.getToken();
    final response = await http.get(
      Uri.parse('$baseUrl$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );
    final processedResponse = jsonDecode(response.body);
    return processedResponse;
  }

  static Future<dynamic> post(
      String endpoint, Map<String, dynamic> body) async {
    String? token = await TokenService.getToken();
    final response = await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode(body),
    );

    final processedResponse = jsonDecode(response.body);
    
    // Guardar token si está en la respuesta
    if (processedResponse is Map<String, dynamic> && processedResponse.containsKey('token')) {
      await TokenService.saveToken(processedResponse['token']);
    }
    
    return processedResponse;
  }

  static Future<dynamic> put(String endpoint, Map<String, dynamic> body) async {
    String? token = await TokenService.getToken();
    final response = await http.put(
      Uri.parse('$baseUrl$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode(body),
    );
    
    final processedResponse = jsonDecode(response.body);
    
    // Guardar token si está en la respuesta
    if (processedResponse is Map<String, dynamic> && processedResponse.containsKey('token')) {
      await TokenService.saveToken(processedResponse['token']);
    }
    
    return processedResponse;
  }

  static Future<dynamic> delete(String endpoint) async {
    String? token = await TokenService.getToken();
    final response = await http.delete(
      Uri.parse('$baseUrl$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );
    return jsonDecode(response.body);
  }
}
