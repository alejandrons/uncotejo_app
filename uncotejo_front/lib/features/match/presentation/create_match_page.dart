import 'package:flutter/material.dart';
import '../../../shared/widgets/top_navigation.dart';
import 'widgets/match_form.dart';

class CreateMatchPage extends StatelessWidget {
  const CreateMatchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Crear Equipo',
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: MatchForm(),
      ),
    );
  }
}
