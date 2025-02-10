import 'package:flutter/material.dart';

class BottomNavigation extends StatelessWidget {
  const BottomNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.sports_soccer),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.sports),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.emoji_events),
          label: '',
        ),
      ],
    );
  }
}