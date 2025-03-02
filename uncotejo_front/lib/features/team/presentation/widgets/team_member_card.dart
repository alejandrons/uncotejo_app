import 'package:flutter/material.dart';
import 'package:uncotejo_front/shared/widgets/custom_widgets.dart';

class TeamMemberCard extends StatelessWidget {
  final String name;
  final bool isLeader;
  final bool isCurrentUserLeader;
  final String? position; // Allow position to be null
  final VoidCallback? onLeaderTransfer;
  final VoidCallback? onExpel;
  final bool isExpanded;
  final VoidCallback onToggleExpand;

  const TeamMemberCard({
    super.key,
    required this.name,
    this.isLeader = false,
    required this.isCurrentUserLeader,
    this.position, // Allow position to be null
    this.onLeaderTransfer,
    this.onExpel,
    required this.isExpanded,
    required this.onToggleExpand,
  });

  @override
  Widget build(BuildContext context) {

    return Card(
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              child: const Icon(Icons.person),
            ),
            title: Text(name),
            subtitle: isLeader
                ? (position != null && position!.isNotEmpty
                  ? Text('Líder de equipo - $position')
                  : Text('Líder de equipo'))
                : (position != null && position!.isNotEmpty
                    ? Text(position!)
                    : const Text(
                        'Jugador')),
            trailing: isCurrentUserLeader && !isLeader
                ? (isExpanded
                    ? Icon(Icons.expand_less)
                    : Icon(Icons.expand_more))
                : null,
            onTap: isCurrentUserLeader && !isLeader ? onToggleExpand : null,
          ),
          if (isExpanded && isCurrentUserLeader && !isLeader)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (onLeaderTransfer != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: CustomTextButton(
                        onPressed: onLeaderTransfer!,
                        text: 'Ceder puesto',
                        backgroundColor: Colors.lightGreen[100],
                        textColor: Colors.black,
                      ),
                    ),
                  const SizedBox(height: 8),
                  if (onExpel != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: CustomTextButton(
                        onPressed: onExpel!,
                        text: 'Expulsar',
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
