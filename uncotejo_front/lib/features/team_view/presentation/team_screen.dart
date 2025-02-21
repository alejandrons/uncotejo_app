import 'package:flutter/material.dart';
import 'widgets/team_member_list.dart';
import 'package:uncotejo_front/shared/widgets/custom_widgets.dart';

class TeamScreen extends StatefulWidget {
  const TeamScreen({super.key});

  @override
  _TeamScreenState createState() => _TeamScreenState();
}

class _TeamScreenState extends State<TeamScreen> {
  bool isCurrentUserLeader = true;
  final String loggedInUserName = 'Armando'; // Replace with the actual logged-in user's name

  void _copyTeamLink() {
    // Handle copy team link action
  }

  void _transferLeadership(String memberName) {
    // Handle transfer leadership action
    print('Transferring leadership to $memberName');
  }

  void _expelMember(String memberName) {
    // Handle expel member action
    print('Expelling member $memberName');
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> teamMembers = [
      {
        'name': 'Armando',
        'isLeader': true,
        'onLeaderTransfer': null,
        'onExpel': null,
      },
      {
        'name': 'Atulya',
        'isLeader': false,
        'onLeaderTransfer': () => _transferLeadership('Atulya'),
        'onExpel': () => _expelMember('Atulya'),
      },
      {
        'name': 'Voltaire',
        'isLeader': false,
        'onLeaderTransfer': () => _transferLeadership('Voltaire'),
        'onExpel': () => _expelMember('Voltaire'),
      },
    ];

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
                loggedInUserName: loggedInUserName,
              ),
            ),
          ],
        ),
      ),
    );
  }
}