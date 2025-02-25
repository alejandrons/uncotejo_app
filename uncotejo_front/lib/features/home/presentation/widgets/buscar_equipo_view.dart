import 'package:flutter/material.dart';
import 'package:uncotejo_front/features/team/presentation/create_team_view.dart';
import 'package:uncotejo_front/features/home/domain/team_model.dart';
import 'package:uncotejo_front/features/home/presentation/widgets/team_card.dart';
import '';


class SearchTeamScreen extends StatelessWidget {
  const SearchTeamScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscar Equipo'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.group_add),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CreateTeamScreen()),
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Notificaciones')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Perfil de usuario')),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: teams.length,
        itemBuilder: (context, index) {
          final team = teams[index];
          return TeamCard(
            teamName: team.name,
            slogan: team.slogan,
            shieldForm: team.shieldForm,
            onJoinPressed: () => _joinTeam(team),
          );
        },
      ),
    );
  }

  void _joinTeam(Team team) {
    // Lógica para unirse a un equipo
    print('Unirse a equipo: ${team.name}');
  }
}