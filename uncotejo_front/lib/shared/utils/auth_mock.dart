import './http_client.dart';
import 'auth_service.dart';

//archivo de utileria para simular el inicio de sesion mientras no haya uno.

class AuthMock {
  static Future<void> login(String email, String password) async {
    try {
      final response = await HttpClient.post('/auth/login', {
        'email': email,
        'password': password,
      });

      if (response.containsKey('token')) {
        await AuthService.saveToken(response['token']);
        print("✅ Token guardado exitosamente: ${response['token']}");
      } else {
        print("❌ Error: No se recibió token en la respuesta.");
      }
    } catch (e) {
      print("❌ Error en el inicio de sesión: $e");
    }
  }

  /// Simular cierre de sesión
  static Future<void> logout() async {
    await AuthService.removeToken();
    print("🔓 Token eliminado. Sesión cerrada.");
  }
}