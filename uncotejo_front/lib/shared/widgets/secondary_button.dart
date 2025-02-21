import 'package:flutter/material.dart';

class SecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Color? color;
  final IconData? leftIcon;
  final IconData? rightIcon;

  const SecondaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.color,
    this.leftIcon,
    this.rightIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: Colors.black,
        backgroundColor: color ?? Colors.grey[200],
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (leftIcon != null) ...[
            Icon(leftIcon, size: 20),
            const SizedBox(width: 8),
          ],
          Text(label, style: const TextStyle(fontSize: 16, color: Colors.black)),
          if (rightIcon != null) ...[
            const SizedBox(width: 8),
            Icon(rightIcon, size: 20),
          ],
        ],
      ),
    );
  }
}
