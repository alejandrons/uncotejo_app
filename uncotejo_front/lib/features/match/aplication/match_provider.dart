import 'package:flutter/material.dart';
import '../domain/match.dart';
import '../domain/possible_dates.dart';
import '../services/match_repository.dart';

class MatchProvider extends ChangeNotifier {
  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  Future<void> createMatch(BuildContext context, PossibleDates possibleDates,
      TimeOfDay fixedTime) async {
    final match = Match(
      possibleDates: possibleDates,
      fixedTime: fixedTime,
    );

    _errorMessage = null;

    await MatchRepository.createMatch(match, context: context)
        .catchError((error) {
      _errorMessage = error.toString();
      notifyListeners();
      return Future<Match>.error(error);
    });
  }
}
