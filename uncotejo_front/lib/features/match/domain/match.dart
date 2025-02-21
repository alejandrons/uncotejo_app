import 'package:flutter/material.dart';
import 'possible_dates.dart';

class Match {
  final int? id; 
  final PossibleDates possibleDates; 
  final TimeOfDay fixedTime; 
  final String? link; 
  final int homeTeamId; 
  final int? awayTeamId; 
  final bool? homeTeamAttendance; 
  final bool? awayTeamAttendance; 

  Match({
    this.id, 
    required this.possibleDates,
    required this.fixedTime,
    this.link, 
    required this.homeTeamId,
    this.awayTeamId,
    this.homeTeamAttendance, 
    this.awayTeamAttendance, 
  });

  Map<String, dynamic> toJson() {
    return {
      'possibleDates': possibleDates.toJson(),
      'fixedTime': "${fixedTime.hour}:${fixedTime.minute}",
      'homeTeamId': homeTeamId,
      'awayTeamId': awayTeamId,
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
    );
  }
}
