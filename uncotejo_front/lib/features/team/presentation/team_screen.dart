import 'package:flutter/material.dart';
import '../domain/team.dart';
import '../services/team_repository.dart';
import 'widgets/team_member_list.dart';
import 'package:uncotejo_front/shared/widgets/custom_widgets.dart';
import 'package:uncotejo_front/shared/widgets/primary_button.dart';
import 'package:uncotejo_front/shared/widgets/top_navigation.dart';
import 'package:flutter/services.dart';

class TeamScreen extends StatefulWidget {
  final VoidCallback onLeaveTeam;

  const TeamScreen({super.key, required this.onLeaveTeam});

  @override
  _TeamScreenState createState() => _TeamScreenState();
}

class _TeamScreenState extends State<TeamScreen> {
  bool isCurrentUserLeader = true;
  final String loggedInUserName = 'Juan';
  Team? team;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadTeam();
  }

  Future<void> _loadTeam() async {
    try {
      final fetchedTeam = await TeamRepository.getTeamById(1); 
      setState(() {
        team = fetchedTeam;
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se pudo cargar el equipo: $error')),
      );
    }
  }

  Future<void> _expelMember(int memberId) async {
    try {
      await TeamRepository.removePlayer(memberId);
      setState(() {
        team?.players!.removeWhere((player) => player.id == memberId);
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se pudo expulsar al miembro: $error')),
      );
    }
  }

  Future<void> _transferLeadership(int memberId) async {
    try {
      await TeamRepository.transferLeadership(memberId);
      setState(() {
        isCurrentUserLeader = false;
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                "No se pudo transferir el liderazgo al jugador: ${team!.players!.firstWhere((player) => player.id == memberId).firstName} ${team!.players!.firstWhere((player) => player.id == memberId).lastName}  $error")),
      );
    }
  }

  void _copyTeamLink() {
    final teamLink = team?.linkAccess;
    if (teamLink != null) {
      Clipboard.setData(ClipboardData(text: teamLink));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Link del equipo copiado al portapapeles')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se pudo copiar el link del equipo')),
      );
    }
  }

  Future<void> _leaveTeam() async {
    try {
      await TeamRepository.leaveTeam(team!.id);
    
    widget.onLeaveTeam();

    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se pudo abandonar el equipo: $error')),
      );
    }
  }

  void _refreshTeam() {
    _loadTeam();
  }

  @override
  Widget build(BuildContext context) {
    if (errorMessage != null) {
      return Scaffold(
        appBar: CustomAppBar(
          title: 'Mi Equipo',
        ),
        body: Center(
          child: Text(errorMessage!),
        ),
      );
    }

    if (team == null) {
      return Scaffold(
        appBar: CustomAppBar(
          title: 'Mi Equipo',
        ),
        body: const Center(
          child: Text('Parece que no estas inscrito en ningún equipo'),
        ),
      );
    }

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Mi Equipo',
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.asset(
              'assets/shields/${team!.shieldForm}',
              width: 100,
              height: 100,
            ),
            const CustomSizedBox(height: 10),
            Text(
              team!.name,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const CustomSizedBox(height: 8),
            Text(
              '"${team!.slogan}"',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
            ),
            const CustomSizedBox(height: 8),
            Text(
              team!.description,
              textAlign: TextAlign.center,
            ),
            const CustomSizedBox(height: 8),
            Text(
              team!.teamType,
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
              onPressed: _leaveTeam,
              label: 'Abandonar equipo',
            ),
            const CustomSizedBox(height: 20),
            Expanded(
              child: TeamMemberList(
                isCurrentUserLeader: isCurrentUserLeader,
                teamMembers: team!.players!,
                loggedInUserName: loggedInUserName,
                onExpelMember: _expelMember,
                onTransferLeadership: _transferLeadership,
                onRefreshTeam: _refreshTeam,
              ),
            ),
          ],
        ),
      ),
    );
  }
}