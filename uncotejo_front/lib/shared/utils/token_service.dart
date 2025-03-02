import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class TokenService {
  static final String _tokenKey = dotenv.env['AUTH_TOKEN_KEY'] ?? "";
    static final String baseUrl = _tokenKey.isNotEmpty ? _tokenKey : throw Exception("AUTH_TOKEN_KEY no definida en .env");

  /// Guardar el token en `shared_preferences`
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  /// Obtener el token guardado
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  /// Eliminar el token (para cerrar sesión)
  static Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }
}