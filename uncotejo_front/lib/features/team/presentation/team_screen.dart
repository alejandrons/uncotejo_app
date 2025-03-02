import 'package:flutter/material.dart';
import 'package:uncotejo_front/shared/utils/token_service.dart';
import '../../../shared/widgets/home_screen.dart';
import '../domain/team.dart';
import '../services/team_repository.dart';
import 'widgets/team_member_list.dart';
import 'package:jwt_decode/jwt_decode.dart';

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
  bool? isCurrentUserLeader;
  Team? team;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadTeam();
  }

  Future<void> _loadTeam() async {
    try {
      final String? token = await TokenService.getToken();
      Map<String, dynamic> decodedToken = Jwt.parseJwt(token!);
      final int? userId = decodedToken["id"];
      final String? role = decodedToken["role"];

      final fetchedTeam = await TeamRepository.getTeamByUserId(userId!);
      setState(() {
        isCurrentUserLeader = role == "team_leader";
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
        team?.players.removeWhere((player) => player.id == memberId);
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
    _loadTeam(); // Reload the team data
  } catch (error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(
              "No se pudo transferir el liderazgo al jugador: ${team!.players.firstWhere((player) => player.id == memberId).name} $error")),
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

    if (isCurrentUserLeader!) {
      ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Debes transferir el liderazgo antes de abandonar el equipo')),
      );
    } else {
      Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const HomeScreen()),
      (Route<dynamic> route) => false,
      );
    }
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Parece que no tienes equipo",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Text(
                "Puedes ir al inicio para unirte a uno o crear uno nuevo",
                style: TextStyle(fontSize: 18, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
          ),
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
                isCurrentUserLeader: isCurrentUserLeader!,
                teamMembers: team!.players,
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
