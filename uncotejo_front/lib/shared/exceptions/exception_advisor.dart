import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiException implements Exception {
  final int statusCode;
  final String message;

  ApiException({required this.statusCode, required this.message});

  @override
  String toString() {
    return 'Error $statusCode: $message';
  }
}

Future<Map<String, dynamic>> processResponse(http.Response response) async {
  try {
    final String responseBody = response.body.trim();
    final Map<String, dynamic>? jsonResponse =
        responseBody.isNotEmpty ? jsonDecode(responseBody) : null;

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonResponse ?? {};
    } else {
      throw ApiException(
        statusCode: response.statusCode,
        message: jsonResponse?['error'] ?? 'Error inesperado en la petición',
      );
    }
  } on ApiException {
    rethrow;
  } catch (e) {
    throw ApiException(
      statusCode: response.statusCode,
      message: 'Error al procesar la respuesta del servidor',
    );
  }
}
