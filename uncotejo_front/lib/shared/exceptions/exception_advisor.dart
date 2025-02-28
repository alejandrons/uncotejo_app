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

Future<dynamic> processResponse(http.Response response) async {
  try {
    final String responseBody = response.body.trim();
    final int statusCode = response.statusCode;

    if (responseBody.isEmpty) {
      return _handleEmptyResponse(statusCode);
    }

    return _parseJsonResponse(responseBody, statusCode);
  } catch (e) {
    throw ApiException(
      statusCode: response.statusCode,
      message: 'Error al procesar la respuesta del servidor: $e',
    );
  }
}

dynamic _handleEmptyResponse(int statusCode) {
  if (_isSuccess(statusCode)) {
    return {}; // Successful but empty response
  }
  throw ApiException(
    statusCode: statusCode,
    message: 'Respuesta vacía con código de error $statusCode',
  );
}

dynamic _parseJsonResponse(String responseBody, int statusCode) {
  try {
    final dynamic jsonResponse = jsonDecode(responseBody);

    if (_isSuccess(statusCode)) {
      return jsonResponse;
    }

    final String errorMessage = _extractErrorMessage(jsonResponse);
    throw ApiException(statusCode: statusCode, message: errorMessage);
  } on FormatException {
    throw ApiException(
      statusCode: statusCode,
      message: 'Error en la respuesta del servidor: $responseBody',
    );
  }
}

bool _isSuccess(int statusCode) => statusCode >= 200 && statusCode < 300;

String _extractErrorMessage(dynamic jsonResponse) {
  if (jsonResponse is Map<String, dynamic> && jsonResponse.containsKey('error')) {
    return jsonResponse['error'];
  }
  return 'Error inesperado en la petición';
}
