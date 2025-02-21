import 'package:flutter/material.dart';

class DatePickerToggle extends StatelessWidget {
  final bool isRangeMode;
  final ValueChanged<bool> onToggle;

  const DatePickerToggle({
    super.key,
    required this.isRangeMode,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Modo de selección:",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Row(
          children: [
            const Text("Días"),
            Switch(
              value: isRangeMode,
              onChanged: onToggle,
            ),
            const Text("Rango"),
          ],
        ),
      ],
    );
  }
}
