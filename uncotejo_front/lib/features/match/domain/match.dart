import 'package:flutter/material.dart';
import 'possible_dates.dart';
import 'parsed_team.dart';

class Match {
  final int? id;
  final PossibleDates possibleDates;
  final TimeOfDay fixedTime;
  final String? link;
  final int? homeTeamId;
  final int? awayTeamId;
  final bool? homeTeamAttendance;
  final bool? awayTeamAttendance;
  final ParsedTeam? homeTeam; 
  final ParsedTeam? awayTeam;

  Match({
    this.id,
    required this.possibleDates,
    required this.fixedTime,
    this.link,
    this.homeTeamId,
    this.awayTeamId,
    this.homeTeamAttendance,
    this.awayTeamAttendance,
    this.homeTeam,
    this.awayTeam,
  });

  Map<String, dynamic> toJson() {
    return {
      'possibleDates': possibleDates.toJson(),
      'fixedTime': "${fixedTime.hour}:${fixedTime.minute}",
    };
  }

  Map<String, dynamic> toJsonFromBackend() {
    return {
      'id': id,
      'possibleDates': possibleDates.toJson(),
      'fixedTime': "${fixedTime.hour}:${fixedTime.minute}",
      'link': link,
      'homeTeamId': homeTeamId,
      'awayTeamId': awayTeamId,
      'homeTeamAttendance': homeTeamAttendance ?? false,
      'awayTeamAttendance': awayTeamAttendance ?? false,
      'homeTeam': homeTeam?.toJson(),
      'awayTeam': awayTeam?.toJson(),
    };
  }

  factory Match.fromJson(Map<String, dynamic> json) {
    return Match(
      id: json['id'],
      possibleDates: PossibleDates.fromJson(json['possibleDates']),
      fixedTime: TimeOfDay(
        hour: int.parse(json['fixedTime'].split(':')[0]),
        minute: int.parse(json['fixedTime'].split(':')[1]),
      ),
      link: json['link'],
      homeTeamId: json['homeTeamId'],
      awayTeamId: json['awayTeamId'],
      homeTeamAttendance: json['homeTeamAttendance'] ?? false,
      awayTeamAttendance: json['awayTeamAttendance'] ?? false,
      homeTeam: json['homeTeam'] != null ? ParsedTeam.fromJson(json['homeTeam']) : null,
      awayTeam: json['awayTeam'] != null ? ParsedTeam.fromJson(json['awayTeam']) : null,
    );
  }
}
