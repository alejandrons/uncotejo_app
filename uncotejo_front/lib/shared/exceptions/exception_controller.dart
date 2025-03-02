import 'package:flutter/material.dart';
import 'package:uncotejo_front/shared/exceptions/exception_advisor.dart';

import '../../main.dart';

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
