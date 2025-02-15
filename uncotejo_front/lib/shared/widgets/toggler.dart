import 'package:flutter/material.dart';

class ToggleSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final String leftLabel;
  final String rightLabel;

  const ToggleSwitch( {
    super.key,
    required this.value,
    required this.onChanged,
    required this.leftLabel,
    required this.rightLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          leftLabel,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Row(
          children: [
            Text(leftLabel),
            Switch(
              value: value,
              onChanged: onChanged,
            ),
            Text(rightLabel),
          ],
        ),
      ],
    );
  }
}
