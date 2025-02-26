import 'dart:async';
import 'package:uncotejo_front/shared/utils/http_client.dart';
import '../domain/team_model.dart';

class TeamServices {
  static const String _teamEndpoint = "/team/";
  
  static Future<List<Team>> getTeams() async {
    print("entro get");
    final response = await HttpClient.get(_teamEndpoint);
    print("ejecuto");
    print(response.toString());
    if (response is! List) {
      throw Exception(
          'Error: La respuesta esperada era una lista, pero se recibió ${response.runtimeType}');
    }

    return response.map((json) => Team.fromJson(json)).toList();
  }
}
