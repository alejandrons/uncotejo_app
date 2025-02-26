import '../domain/team.dart';
import 'package:uncotejo_front/shared/utils/http_client.dart';

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
}