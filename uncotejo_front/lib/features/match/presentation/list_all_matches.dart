import 'package:flutter/material.dart';
import '../../../shared/widgets/bottom_navigation.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../../shared/widgets/secondary_button.dart';
import '../../../shared/widgets/template_cartd.dart';

class MatchListScreen extends StatelessWidget {
  const MatchListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> matches = [
      {
        "teamName": "Nombre equipo",
        "stars": "☆☆☆☆☆",
        "availability": "Disponible:\ndesde: 01/03/24\nhasta: 10/03/24",
        "time": "Hora: 18:00",
      },
      {
        "teamName": "Nombre equipo",
        "stars": "☆☆☆☆☆",
        "availability": "Disponible:\ndías: martes-jueves",
        "time": "Hora: HH:mm",
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Lista de equipos en búsqueda de partidos"),
        backgroundColor: Colors.grey[300],
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            PrimaryButton(
              label: "Crear partido",
              color: Colors.blueAccent,
              leftIcon: Icons.add,
              onPressed: () {
                Navigator.pushNamed(context, '/create-match');
              },
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: matches.length,
                itemBuilder: (context, index) {
                  final match = matches[index];

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: TemplateCard(
                      title: "vs ${match["teamName"]}",
                      attributes: [
                        {"text": match["stars"], "icon": null},
                        {
                          "text": match["availability"],
                          "icon": Icons.calendar_today
                        },
                        {"text": match["time"], "icon": Icons.access_time},
                      ],
                      buttons: [
                        PrimaryButton(
                          label: "Pactar partido",
                          color: Colors.grey[600],
                          onPressed: () {},
                        ),
                        SecondaryButton(
                          label: "Copiar link del Partido",
                          leftIcon: Icons.copy,
                          onPressed: () {},
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavigation(),
    );
  }
}
