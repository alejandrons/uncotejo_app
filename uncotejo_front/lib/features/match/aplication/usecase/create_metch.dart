import 'package:flutter/material.dart';
import '../../../../shared/utils/http_client.dart';
import '../../domain/match.dart';
import '../../domain/possible_dates.dart';
import '../../services/match_repository.dart';

class CreateMatchUseCase {
  Future<Match> execute(PossibleDates possibleDates, TimeOfDay fixedTime) async {
    try {
      // Simulación del ID del equipo local (hasta que tengamos autenticación)
      int simulatedHomeTeamId = 1;  // TODO: crear lógica para unir con el id del team del líder

      final match = Match(
        possibleDates: possibleDates,
        fixedTime: fixedTime,
        homeTeamId: simulatedHomeTeamId,
      );

      return await MatchRepository.createMatch(match);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(statusCode: 500, message: 'Error inesperado al crear partido');
    }
  }
}
