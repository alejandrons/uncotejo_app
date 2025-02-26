import 'package:flutter/material.dart';
import 'package:uncotejo_front/features/home/presentation/home_page.dart';
import 'package:uncotejo_front/features/team_view/presentation/team_screen.dart';

import '../../features/match/presentation/list_all_matches.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  //TODO: Implementar las pantallas de Home y Soccer
  final List<Widget> _screens = [
    const HomePage(), // Pantalla de Home
    const TeamScreen(), // Pantalla de Soccer (o futura implementación)
    const MatchListPage(),
    const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center, // Centrar verticalmente
        crossAxisAlignment:
            CrossAxisAlignment.center, // Centrar horizontalmente
        children: [
          Text(
            "Eventos",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10), // Espacio entre líneas
          Text(
            "Coming Soon",
            style: TextStyle(fontSize: 18, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ), // Pantalla de Eventos
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sports_soccer),
            label: 'Equipo',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sports),
            label: 'Partidos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.emoji_events),
            label: 'Eventos',
          ),
        ],
      ),
    );
  }
}
