import 'package:uncotejo_front/features/team/domain/team.dart';
import 'package:uncotejo_front/shared/utils/http_client.dart';
import 'package:uncotejo_front/features/match/domain/parsed_team.dart';

class TeamRepository {
  static const String _teamEndpoint = "/team";

  static Future<Team> getTeamById(int id) async {
    final response = await HttpClient.get("$_teamEndpoint/$id");
    return Team.fromJson(response);
  }

  static Future<void> removePlayer(int playerId) async {
    await HttpClient.delete("$_teamEndpoint/remove/$playerId");
  }

  static Future<void> transferLeadership(int playerId) async {
    await HttpClient.put("$_teamEndpoint/transfer/$playerId", {});
  }

  static Future<void> leaveTeam(int teamId) async {
    await HttpClient.delete("$_teamEndpoint/leave");
  }

static Future<List<ParsedTeam>> getTeams() async {
  final response = await HttpClient.get("$_teamEndpoint/");

  // Asegurar que response es una lista antes de mapear
  if (response is List) {
    return response.map((json) => ParsedTeam.fromJson(json as Map<String, dynamic>)).toList();
  } else {
    throw Exception("La respuesta del servidor no es una lista de equipos");
  }
}

}
