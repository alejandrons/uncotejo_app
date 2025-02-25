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

    // Verificar si el cuerpo de la respuesta está vacío
    if (responseBody.isEmpty) {
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return {}; // Devolver un mapa vacío si la respuesta fue exitosa pero sin contenido
      } else {
        throw ApiException(
          statusCode: response.statusCode,
          message: 'Respuesta vacía con código de error ${response.statusCode}',
        );
      }
    }

    // Intentar decodificar el JSON
    try {
      final dynamic jsonResponse = jsonDecode(responseBody);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return jsonResponse; // Puede ser un objeto o una lista
      } else {
        // Si la respuesta es un error con estructura JSON, extraer el mensaje de error
        String errorMessage = 'Error inesperado en la petición';
        if (jsonResponse is Map<String, dynamic> && jsonResponse.containsKey('error')) {
          errorMessage = jsonResponse['error'];
        }

        throw ApiException(
          statusCode: response.statusCode,
          message: errorMessage,
        );
      }
    } on FormatException catch (_) {
      // Si el JSON no se pudo decodificar correctamente, mostrar el mensaje original del servidor
      throw ApiException(
        statusCode: response.statusCode,
        message: 'Error en la respuesta del servidor: ${response.body}',
      );
    }
  } catch (e) {
    throw ApiException(
      statusCode: response.statusCode,
      message: 'Error al procesar la respuesta del servidor: $e',
    );
  }
}
