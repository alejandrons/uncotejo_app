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
    _loadTeams();
  }

  void _loadTeams() {
    setState(() {
      _teamsFuture = TeamRepository.getTeams();
    });
  }

  Future<void> _joinTeam(String teamLink) async {
    try {
      await TeamRepository.joinTeam(teamLink);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Te has unido al equipo con éxito!')),
      );
      _loadTeams(); // Refresca la lista de equipos
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al unirse al equipo: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Lista de Equipos disponibles',
        leadingIcon: Icons.group_add,
        onLeadingPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateTeamScreen()),
          );
        },
      ),
      body: FutureBuilder<List<ParsedTeam>>(
        future: _teamsFuture, 
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search_off, size: 80, color: Colors.grey),
                  SizedBox(height: 10),
                  Text(
                    "No hay equipos disponibles",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          final teams = snapshot.data!;
          return ListView.builder(
            itemCount: teams.length,
            itemBuilder: (context, index) {
              final team = teams[index];
              return TeamCard(
                teamName: team.name,
                shieldForm: team.shieldForm,
                teamLink: team.linkAccess,
                onJoined: _loadTeams, // Recarga la lista tras unirse
              );
            },
          );
        },
      ),
    );
  }
}
