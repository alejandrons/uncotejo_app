import 'package:flutter/material.dart';
import 'team_member_card.dart';

class TeamScreen extends StatelessWidget {
  const TeamScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ver Equipo: líder de equipo'),
        backgroundColor: Colors.grey[200],
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
            // Team Info Section
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey,
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
            TextFormField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Descripción',
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                // Handle leave team action
              },
              child: const Text('Abandonar equipo'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[400],
              ),
            ),
            const SizedBox(height: 20),

            // Team Members Section
            Expanded(
              child: ListView(
                children: [
                  TeamMemberCard(
                    name: 'CentroCampos',
                    isLeader: true,
                    onLeaderTransfer: () {
                      // Handle leader transfer action
                    },
                  ),
                  const SizedBox(height: 8),
                  TeamMemberCard(
                    name: 'Atulya',
                    onExpel: () {
                      // Handle expel member action
                    },
                  ),
                  const SizedBox(height: 8),
                  TeamMemberCard(
                    name: 'Voltaire',
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
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '',
          ),
        ],
      ),
    );
  }
}
