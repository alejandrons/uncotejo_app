import 'package:flutter/material.dart';
import 'exception_advisor.dart';

class ExceptionController {
  static void handleException(BuildContext context, dynamic error) {
    String errorMessage;
    if (error is ApiException) {
      errorMessage = error.message;
    } else {
      errorMessage = 'Ha ocurrido un error inesperado.';
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(errorMessage),
        backgroundColor: Colors.red,
      ),
    );
  }
}
