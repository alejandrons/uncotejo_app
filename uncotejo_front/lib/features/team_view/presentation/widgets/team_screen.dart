import 'package:flutter/material.dart';
import 'team_member_list.dart';
import 'package:uncotejo_front/shared/widgets/bottom_navigation.dart';
import 'package:uncotejo_front/shared/widgets/custom_widgets.dart';

class TeamScreen extends StatefulWidget {
  const TeamScreen({super.key});

  @override
  _TeamScreenState createState() => _TeamScreenState();
}

class _TeamScreenState extends State<TeamScreen> {
  bool isCurrentUserLeader = true;

  void _copyTeamLink() {
    // Handle copy team link action
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> teamMembers = [
      {
        'name': 'Armando',
        'isLeader': true,
        'onLeaderTransfer': () {
          // Handle leader transfer action
        },
        'onExpel': null,
      },
      {
        'name': 'Atulya',
        'isLeader': false,
        'onLeaderTransfer': null,
        'onExpel': () {
          // Handle expel member action
        },
      },
      {
        'name': 'Voltaire',
        'isLeader': false,
        'onLeaderTransfer': null,
        'onExpel': () {
          // Handle expel member action
        },
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Equipo'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Handle back button action
          },
        ),
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
            const Text(
              'Equipo',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const CustomSizedBox(height: 8),
            const Text(
              'Slogan de ejemplo',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
            ),
            const CustomSizedBox(height: 8),
            const Text(
              'Descripción',
              textAlign: TextAlign.center,
            ),
            const CustomSizedBox(height: 8),
            CustomElevatedButton(
              onPressed: _copyTeamLink,
              text: 'Copiar link del equipo',
            ),
            const CustomSizedBox(height: 8),
            CustomElevatedButton(
              onPressed: () {
                // Handle leave team action
              },
              text: 'Abandonar equipo',
            ),
            const CustomSizedBox(height: 20),
            Expanded(
              child: TeamMemberList(
                isCurrentUserLeader: isCurrentUserLeader,
                teamMembers: teamMembers,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavigation(),
    );
  }
}