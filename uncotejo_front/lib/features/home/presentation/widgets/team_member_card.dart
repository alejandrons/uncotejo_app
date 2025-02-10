import 'package:flutter/material.dart';

class TeamMemberCard extends StatelessWidget {
  final String name;
  final bool isLeader;
  final VoidCallback? onLeaderTransfer;
  final VoidCallback? onExpel;

  const TeamMemberCard({
    Key? key,
    required this.name,
    this.isLeader = false,
    this.onLeaderTransfer,
    this.onExpel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.grey,
          child: const Icon(Icons.person),
        ),
        title: Text(name),
        subtitle: isLeader ? const Text('Líder de equipo') : null,
        trailing: isLeader
            ? TextButton(
                onPressed: onLeaderTransfer,
                child: const Text('Ceder puesto'),
              )
            : TextButton(
                onPressed: onExpel,
                child: const Text('Expulsar'),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
              ),
      ),
    );
  }
}
