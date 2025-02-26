import 'package:flutter/material.dart';
import 'package:uncotejo_front/features/match/presentation/list_all_matches.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../match/presentation/create_match_page.dart';

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
                MaterialPageRoute(
                    builder: (context) => const CreateMatchPage());
              },
            ),
            const SizedBox(height: 16), // Espaciado entre botones
            PrimaryButton(
                label: "Listar Partidos",
                color: Colors.green, // Diferente color para distinguirlo
                onPressed: () {
                  MaterialPageRoute(
                      builder: (context) => const MatchListPage());
                }),
          ],
        ),
      ),
    );
  }
}