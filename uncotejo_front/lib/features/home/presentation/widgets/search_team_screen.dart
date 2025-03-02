import 'package:flutter/material.dart';
import 'package:uncotejo_front/features/home/presentation/widgets/create_team_screen.dart';
import 'package:uncotejo_front/features/match/domain/parsed_team.dart';
import 'package:uncotejo_front/features/home/presentation/widgets/team_card.dart';
import 'package:uncotejo_front/features/team/services/team_repository.dart';

import '../../../../shared/widgets/top_navigation.dart';

class SearchTeamScreen extends StatefulWidget {
  const SearchTeamScreen({super.key});

  @override
  _SearchTeamState createState() => _SearchTeamState();
}

class _SearchTeamState extends State<SearchTeamScreen> {
  late Future<List<ParsedTeam>> _teamsFuture;

  @override
  void initState() {
    super.initState();
    _teamsFuture = TeamRepository.getTeams();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Lista de equipos en búsqueda de partidos',
        leadingIcon: Icons.group_add,
        onLeadingPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateTeamScreen()),
          );
        },
      ),
      body: FutureBuilder<List<ParsedTeam>>(
        future: _teamsFuture, // Obtiene los equipos del backend
        builder: (context, snapshot) {
          // Center(child: Text(context));
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Muestra un indicador de carga mientras se obtienen los datos
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Muestra un mensaje de error si la solicitud falla
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            // Muestra un mensaje si no hay equipos
            return const Center(child: Text('No hay equipos disponibles.'));
          } else {
            // Muestra la lista de equipos
            final teams = snapshot.data!;
            return ListView.builder(
              itemCount: teams.length,
              itemBuilder: (context, index) {
                final team = teams[index];
                return TeamCard(
                  teamName: team.name,
                  shieldForm: team.shieldForm,
                  onJoinPressed: () => {},
                );
              },
            );
          }
        },
      ),
    );
  }
}
