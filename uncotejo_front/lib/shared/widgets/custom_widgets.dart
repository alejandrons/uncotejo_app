import 'package:flutter/material.dart';

class CustomCircleAvatar extends StatelessWidget {
  final double radius;
  final IconData icon;
  final double iconSize;

  const CustomCircleAvatar({
    super.key,
    required this.radius,
    required this.icon,
    required this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      child: Icon(icon, size: iconSize),
    );
  }
}

class CustomSizedBox extends StatelessWidget {
  final double height;

  const CustomSizedBox({super.key, required this.height});

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: height);
  }
}

class CustomTextButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final Color? backgroundColor;
  final Color? textColor;

  const CustomTextButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        backgroundColor: backgroundColor,
      ),
      child: Text(
        text,
        style: TextStyle(color: textColor),
      ),
    );
  }
}