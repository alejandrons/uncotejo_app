import 'package:flutter/material.dart';
import '../domain/match.dart';
import 'package:uncotejo_front/shared/utils/http_client.dart';

class MatchRepository {
  static const String _matchEndpoint = "/match";

  static Future<Match> createMatch(Match match) async {
    final response = await HttpClient.post(
      "$_matchEndpoint/",
      match.toJson(),
    );
    return Match.fromJson(response);
  }

  static Future<List<Match>> getAllMatches() async {
    final response = await HttpClient.get("$_matchEndpoint/");
    return (response as List).map((match) => Match.fromJson(match)).toList();
  }

  static Future<Match?> getMatchById(int id) async {
    final response = await HttpClient.get("$_matchEndpoint/$id");
    return Match.fromJson(response);
  }

  static Future<Match?> getMatchByLink(String link) async {
    final response = await HttpClient.get("$_matchEndpoint/link/$link");
    return Match.fromJson(response);
  }

  static Future<Match> makeMatchById(int matchId, int awayTeamId, TimeOfDay fixedTime) async {
    final response = await HttpClient.put(
      "$_matchEndpoint/$matchId/match",
      {
        "awayTeamId": awayTeamId,
        "fixedTime": "${fixedTime.hour}:${fixedTime.minute}"
      },
    );
    return Match.fromJson(response);
  }

  static Future<Match> makeMatchByLink(String link, int awayTeamId, TimeOfDay fixedTime) async {
    final response = await HttpClient.put(
      "$_matchEndpoint/link/$link/match",
      {
        "awayTeamId": awayTeamId,
        "fixedTime": "${fixedTime.hour}:${fixedTime.minute}"
      },
    );
    return Match.fromJson(response);
  }
}
