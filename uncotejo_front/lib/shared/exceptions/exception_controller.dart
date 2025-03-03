import 'package:flutter/material.dart';

import '../../main.dart';
import 'exception_advisor.dart';

class ExceptionController {
  static void handleException(dynamic error) {
    String errorMessage;
    if (error is ApiException) {
      errorMessage = error.message;
    } else {
      errorMessage = 'Ha ocurrido un error inesperado.';
    }

    scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(errorMessage),
        backgroundColor: Colors.red,
      ),
    );
  }
}
