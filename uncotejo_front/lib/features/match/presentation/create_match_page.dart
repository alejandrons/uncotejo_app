import 'package:flutter/material.dart';
import 'widgets/match_form.dart';

class CreateMatchPage extends StatelessWidget {
  const CreateMatchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Crear Partido"),

      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: MatchForm(),
      ),
    );
  }
}
