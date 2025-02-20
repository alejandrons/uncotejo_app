import 'package:flutter/material.dart';
import '../../domain/match.dart';
import '../../domain/possible_dates.dart';
import '../../services/match_repository.dart';

class MatchProvider extends ChangeNotifier {

  Future<void> createMatch(PossibleDates possibleDates, TimeOfDay fixedTime) async {
    await MatchRepository.createMatch(
      Match(
        possibleDates: possibleDates,
        fixedTime: fixedTime,
        homeTeamId: 1,
      ),
    );
    notifyListeners();
  }
}
