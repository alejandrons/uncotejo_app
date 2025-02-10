import 'package:flutter/material.dart';

class TeamMemberCard extends StatelessWidget {
  final String name;
  final bool isLeader;
  final bool isCurrentUserLeader;
  final VoidCallback? onLeaderTransfer;
  final VoidCallback? onExpel;

  const TeamMemberCard({
    super.key,
    required this.name,
    this.isLeader = false,
    required this.isCurrentUserLeader,
    this.onLeaderTransfer,
    this.onExpel,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.greenAccent,
          child: const Icon(Icons.person),
        ),
        title: Text(name),
        subtitle: isLeader ? const Text('Líder de equipo') : null,
        trailing: isCurrentUserLeader
            ? isLeader
                ? TextButton(
                    onPressed: onLeaderTransfer,
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.lightGreen[100],
                    ),
                    child: const Text(
                      'Ceder puesto',
                      style: TextStyle(color: Colors.black),
                    ),
                    )
                  : TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    onPressed: onExpel,
                    child: const Text(
                      'Expulsar',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
            : null,
      ),
    );
  }
}