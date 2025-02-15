import 'package:flutter/material.dart';

import '../../domain/match.dart';
import '../../domain/possible_dates.dart';
import '../../services/match_repository.dart';

class CreateMatchUseCase {

  Future<Match> execute(PossibleDates possibleDates, TimeOfDay fixedTime) async {
    // Simulación del ID del equipo local (hasta que tengamos autenticación)
    int simulatedHomeTeamId = 1;  //TODO: crear logica para unir con el id del team del lider

    final match = Match(
      possibleDates: possibleDates,
      fixedTime: fixedTime,
      homeTeamId: simulatedHomeTeamId,
    );

    return await MatchRepository.createMatch(match);
  }
}
