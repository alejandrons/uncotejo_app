
import 'package:flutter/material.dart';
import 'package:uncotejo_front/shared/utils/http_client.dart';

class TeamInfo {
  static const String _teamEndpoint = "/team";

  static Future<Team> createteam(Team team) async {
    final response = await HttpClient.post(
      "$_teamEndpoint/",
      team.toJson(),
    );
    return team.fromJson(response);
  }

  static Future<List<Team>> getAllteames() async {
    final response = await HttpClient.get("$_teamEndpoint/");
    return (response as List).map((team) => team.fromJson(team)).toList();
  }

  static Future<Team?> getteamById(int id) async {
    final response = await HttpClient.get("$_teamEndpoint/$id");
    return Team.fromJson(response);
  }

  static Future<Team?> getteamByLink(String link) async {
    final response = await HttpClient.get("$_teamEndpoint/link/$link");
    return Team.fromJson(response);
  }

  static Future<Team> maketeamById(int teamId, int awayTeamId, TimeOfDay fixedTime) async {
    final response = await HttpClient.put(
      "$_teamEndpoint/$teamId/team",
      {
        "awayTeamId": awayTeamId,
        "fixedTime": "${fixedTime.hour}:${fixedTime.minute}"
      },
    );
    return Team.fromJson(response);
  }

  static Future<Team> maketeamByLink(String link, int awayTeamId, TimeOfDay fixedTime) async {
    final response = await HttpClient.put(
      "$_teamEndpoint/link/$link/team",
      {
        "awayTeamId": awayTeamId,
        "fixedTime": "${fixedTime.hour}:${fixedTime.minute}"
      },
    );
    return Team.fromJson(response);
  }
}
