import 'package:intl/intl.dart';

import '../../features/match/domain/possible_dates.dart';

class DateUtil {
  static String formatDate(DateTime date) {
    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    return formatter.format(date);
  }

  static String? formatPossibleDates(PossibleDates possibleDates) {
    if (possibleDates.days != null) {
      return 'Días: ${possibleDates.days!.join(", ")}';
    } else if (possibleDates.from != null && possibleDates.to != null) {
      return 'Rango: ${formatDate(possibleDates.from!)} - ${formatDate(possibleDates.to!)}';
    }
    return null;
  }
}
