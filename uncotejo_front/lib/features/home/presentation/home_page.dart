import 'package:flutter/material.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../../shared/widgets/bottom_navigation.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Inicio")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            PrimaryButton(
              label: "Crear Partido",
              color: Colors.blueAccent,
              onPressed: () {
                Navigator.pushNamed(context, '/create-match');
              },
            ),
            const SizedBox(height: 20),
            PrimaryButton(
              label: "Mi Equipo",
              color: Colors.greenAccent,
              onPressed: () {
                Navigator.pushNamed(context, '/my-team');
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavigation(),
    );
  }
}