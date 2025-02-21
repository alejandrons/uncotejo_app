import 'package:flutter/material.dart';
import '../../../shared/widgets/bottom_navigation.dart';
import '../../../shared/widgets/primary_button.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Inicio")),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            PrimaryButton(
              label: "Crear Partido",
              color: Colors.blueAccent,
              onPressed: () {
                Navigator.pushNamed(context, '/create-match'); // Navega a crear partido
              },
            ),
            const SizedBox(height: 16), // Espaciado entre botones
            PrimaryButton(
              label: "Listar Partidos",
              color: Colors.green, // Diferente color para distinguirlo
              onPressed: () {
                Navigator.pushNamed(context, '/list-matches'); // Navega a listar partidos
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavigation(),
    );
  }
}
