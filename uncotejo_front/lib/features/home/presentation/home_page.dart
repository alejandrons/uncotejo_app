import 'package:flutter/material.dart';
import '../../../shared/widgets/bottom_navigation.dart';
import '../../../shared/widgets/primary_button.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Inicio")),
      body: Center(
        child: PrimaryButton(
          label: "Crear Partido",
          color: Colors.blueAccent,
          onPressed: () {
            Navigator.pushNamed(context, '/create-match');
          },
        ),
      ),
      bottomNavigationBar: const BottomNavigation(),
    );
  }
}
