import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../application/team_provider.dart';
import 'widgets/team_member_list.dart';
import 'package:uncotejo_front/shared/widgets/custom_widgets.dart';
import 'package:uncotejo_front/shared/widgets/bottom_navigation.dart';
import 'package:uncotejo_front/shared/widgets/primary_button.dart';

class TeamScreen extends StatefulWidget {
  const TeamScreen({super.key});

  @override
  _TeamScreenState createState() => _TeamScreenState();
}

class _TeamScreenState extends State<TeamScreen> {
  bool isCurrentUserLeader = true;
  final String loggedInUserName = 'Armando'; // Replace with the actual logged-in user's name

  @override
  void initState() {
    super.initState();
    _loadTeam();
  }

  void _loadTeam() {
    final teamProvider = Provider.of<TeamProvider>(context, listen: false);
    teamProvider.getTeamById(context, 1); // Replace with the actual team ID
    teamProvider.getTeamMembers(context, 1); // Replace with the actual team ID
  }

  void _copyTeamLink() {
    // Handle copy team link action
  }



  @override
  Widget build(BuildContext context) {
    final teamProvider = Provider.of<TeamProvider>(context);
    final team = teamProvider.team;
    final teamMembers = teamProvider.teamMembers;

    if (teamProvider.errorMessage != null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Mi Equipo'),
        ),
        body: Center(
          child: Text(teamProvider.errorMessage!),
        ),
      );
    }

    if (team == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Mi Equipo'),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Equipo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const CustomCircleAvatar(
              radius: 50,
              icon: Icons.person,
              iconSize: 50,
            ),
            const CustomSizedBox(height: 10),
            Text(
              team.name,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const CustomSizedBox(height: 8),
            Text(
              team.slogan,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
            ),
            const CustomSizedBox(height: 8),
            Text(
              team.description,
              textAlign: TextAlign.center,
            ),
            const CustomSizedBox(height: 8),
            PrimaryButton(
              onPressed: _copyTeamLink,
              leftIcon: Icons.copy,
              label: 'Copiar link del equipo',
            ),
            const CustomSizedBox(height: 8),
            PrimaryButton(
              onPressed: () {
                // Handle leave team action
              },
              label: 'Abandonar equipo',
            ),
            const CustomSizedBox(height: 20),
            Expanded(
              child: TeamMemberList(
                isCurrentUserLeader: isCurrentUserLeader,
                teamMembers: teamMembers,
                loggedInUserName: loggedInUserName,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavigation(),
    );
  }
}