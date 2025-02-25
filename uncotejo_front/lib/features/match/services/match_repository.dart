import 'package:flutter/material.dart';
import '../../../shared/exceptions/exception_controller.dart';
import '../../../shared/utils/http_client.dart';
import '../domain/match.dart';

class MatchRepository {
  static const String _matchEndpoint = "/match";

  /// **Crear un partido**
  static Future<Match> createMatch(Match match, {required BuildContext context}) async {
    return await HttpClient.post(
      _matchEndpoint,
      {
        "possibleDates": match.possibleDates.toJson(),
        "fixedTime": "${match.fixedTime.hour.toString().padLeft(2, '0')}:${match.fixedTime.minute.toString().padLeft(2, '0')}"
      },
    ).catchError((error) {
      ExceptionController.handleException(context, error);
      return Future<Map<String, dynamic>>.error(error);
    }).then((response) => Match.fromJson(response));
  }

  /// **Obtener todos los partidos disponibles**
  static Future<List<Match>> getAllMatches() async {
    final response = await HttpClient.get(_matchEndpoint);
    return (response as List).map((match) => Match.fromJson(match)).toList();
  }

  /// **Obtener los partidos del equipo del usuario**
  static Future<List<Match>> getMatchesForUserTeam() async {
    final response = await HttpClient.get("$_matchEndpoint/team");
    return (response as List).map((match) => Match.fromJson(match)).toList();
  }

  /// **Obtener partido por ID**
  static Future<Match?> getMatchById(int id) async {
    final response = await HttpClient.get("$_matchEndpoint/$id");
    return Match.fromJson(response);
  }

  /// **Obtener partido por Link**
  static Future<Match?> getMatchByLink(String link) async {
    final response = await HttpClient.get("$_matchEndpoint/link/$link");
    return Match.fromJson(response);
  }

  /// **Actualizar un partido por ID**
  static Future<Match> makeMatchById(
      int matchId, TimeOfDay fixedTime, Map<String, dynamic> possibleDates) async {
    final response = await HttpClient.put(
      "$_matchEndpoint/$matchId",
      {
        "possibleDates": possibleDates,
        "fixedTime": "${fixedTime.hour.toString().padLeft(2, '0')}:${fixedTime.minute.toString().padLeft(2, '0')}"
      },
    );
    return Match.fromJson(response);
  }

  /// **Actualizar un partido por Link**
  static Future<Match> makeMatchByLink(
      String link, TimeOfDay fixedTime, Map<String, dynamic> possibleDates) async {
    final response = await HttpClient.put(
      "$_matchEndpoint/link/$link",
      {
        "possibleDates": possibleDates,
        "fixedTime": "${fixedTime.hour.toString().padLeft(2, '0')}:${fixedTime.minute.toString().padLeft(2, '0')}"
      },
    );
    return Match.fromJson(response);
  }
}
