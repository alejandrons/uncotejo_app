class PossibleDates {
  final List<String>? days; // Lista de días ["Lunes", "Martes", ...]
  final DateTime? from; // Fecha de inicio del rango
  final DateTime? to; // Fecha de fin del rango

  PossibleDates.days(this.days)
      : from = null,
        to = null;

  PossibleDates.range(this.from, this.to)
      : days = null;

  Map<String, dynamic> toJson() {
    if (days != null) {
      return {'days': days};
    } else if (from != null && to != null) {
      return {'range': {'from': from!.toIso8601String(), 'to': to!.toIso8601String()}};
    }
    return {};
  }

  factory PossibleDates.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('days')) {
      return PossibleDates.days(List<String>.from(json['days']));
    } else if (json.containsKey('range')) {
      return PossibleDates.range(
        DateTime.parse(json['range']['from']),
        DateTime.parse(json['range']['to']),
      );
    }
    throw ArgumentError('Invalid JSON for PossibleDates');
  }
}
