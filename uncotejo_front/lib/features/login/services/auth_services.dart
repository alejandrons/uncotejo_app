import 'package:flutter/material.dart';
import '../../../shared/exceptions/exception_controller.dart';
import '../../../shared/utils/http_client.dart';

class AuthService {
  static const String _authEndpoint = "/auth/";

  /// **Iniciar sesión**
  static Future<Map<String, dynamic>> login(String email, String password,
      {required BuildContext context}) async {
    return await HttpClient.post(
      "$_authEndpoint/login",
      {
        "email": email,
        "password": password,
      },
    ).catchError((error) {
      ExceptionController.handleException(error);
      return Future<Map<String, dynamic>>.error(error);
    }).then((response) => response as Map<String, dynamic>);
  }

  /// **Registrar usuario**
  static Future<Map<String, dynamic>> register(
      String name, String email, String password,
      {required BuildContext context}) async {
    return await HttpClient.post(
      "$_authEndpoint/register",
      {
        "name": name,
        "email": email,
        "password": password,
      },
    ).catchError((error) {
      ExceptionController.handleException(error);
      return Future<Map<String, dynamic>>.error(error);
    }).then((response) => response as Map<String, dynamic>);
  }

  static Future<bool> isUserInTeam(int id) async {
    var response = await HttpClient.get("$_authEndpoint/$id");
    return response;
  }
}
