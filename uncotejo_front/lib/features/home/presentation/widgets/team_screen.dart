import 'package:flutter/material.dart';
import 'team_member_card.dart';
import 'package:uncotejo_front/shared/widgets/bottom_navigation.dart';

class TeamScreen extends StatelessWidget {
  const TeamScreen({super.key});

  void _copyTeamLink() {
  }

  @override
  Widget build(BuildContext context) {
    bool isCurrentUserLeader = true;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Equipo'),
        backgroundColor: Colors.lightGreenAccent[200],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.lightGreenAccent,
              child: Icon(Icons.person, size: 50),
            ),
            const SizedBox(height: 10),
            const Text(
              'Equipo',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Slogan de ejemplo',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 8),
            Text(
              'Descripción',             
              textAlign: TextAlign.center,  
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _copyTeamLink,
              style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[400],
              ),
              child: const Text(
              'Copiar link del equipo',
              style: TextStyle(color: Colors.black),
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
              },
              style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[400],
              ),
              child: const Text(
              'Abandonar equipo',
              style: TextStyle(color: Colors.black),
              ),
            ),
            const SizedBox(height: 20),

            Expanded(
              child: ListView(
                children: [
                  TeamMemberCard(
                    name: 'Armando',
                    isLeader: true,
                    isCurrentUserLeader: isCurrentUserLeader,
                    onLeaderTransfer: () {
                    },
                  ),
                  const SizedBox(height: 8),
                  TeamMemberCard(
                    name: 'Atulya',
                    isCurrentUserLeader: isCurrentUserLeader,
                    onExpel: () {
                    },
                  ),
                  const SizedBox(height: 8),
                  TeamMemberCard(
                    name: 'Voltaire',
                    isCurrentUserLeader: isCurrentUserLeader,
                    onExpel: () {
                      // Handle expel member action
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavigation(),
    );
  }
}