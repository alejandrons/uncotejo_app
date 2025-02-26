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

    final dynamic jsonResponse = jsonDecode(responseBody);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonResponse; // Puede ser una lista o un objeto
    } else {
      throw ApiException(
        statusCode: response.statusCode,
        message: (jsonResponse is Map<String, dynamic> && jsonResponse.containsKey('error'))
            ? jsonResponse['error']
            : 'Error inesperado en la petición',
      );
    }
  } on FormatException {
    throw ApiException(
      statusCode: response.statusCode,
      message: 'La respuesta del servidor no es un JSON válido',
    );
  } catch (e) {
    throw ApiException(
      statusCode: response.statusCode,
      message: 'Error al procesar la respuesta del servidor: $e',
    );
  }
}
