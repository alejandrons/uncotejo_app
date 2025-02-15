import 'package:flutter/material.dart';

class DayCircle extends StatelessWidget {
  final String dayInitial;
  final bool isSelected;
  final VoidCallback onTap;

  const DayCircle({
    super.key,
    required this.dayInitial,
    required this.isSelected,
    required this.onTap,
  });

  static const Map<String, String> dayNames = {
    "L": "Lunes",
    "M": "Martes",
    "X": "Miércoles",
    "J": "Jueves",
    "V": "Viernes",
    "S": "Sábado",
    "D": "Domingo",
  };

  String get fullDayName => dayNames[dayInitial] ?? dayInitial;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected ? Colors.blue.shade300 : Colors.grey.shade300,
        ),
        alignment: Alignment.center,
        child: Text(
          dayInitial,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}
