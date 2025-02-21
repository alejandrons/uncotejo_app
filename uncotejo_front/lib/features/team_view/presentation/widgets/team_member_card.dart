import 'package:flutter/material.dart';
import 'package:uncotejo_front/shared/widgets/custom_widgets.dart';

class TeamMemberCard extends StatelessWidget {
  final String name;
  final bool isLeader;
  final bool isCurrentUserLeader;
  final String loggedInUserName;
  final VoidCallback? onLeaderTransfer;
  final VoidCallback? onExpel;
  final bool isExpanded;
  final VoidCallback onToggleExpand;

  const TeamMemberCard({
    super.key,
    required this.name,
    this.isLeader = false,
    required this.isCurrentUserLeader,
    required this.loggedInUserName,
    this.onLeaderTransfer,
    this.onExpel,
    required this.isExpanded,
    required this.onToggleExpand,
  });

  @override
  Widget build(BuildContext context) {
    final bool isLoggedInUser = name == loggedInUserName;

    return Card(
      color: isLoggedInUser ? Colors.blue[50] : null, // Highlight the card if it belongs to the logged-in user
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              child: const Icon(Icons.person),
            ),
            title: Text(name),
            subtitle: isLeader ? const Text('Líder de equipo') : null,
            trailing: isCurrentUserLeader && !isLeader
                ? (isExpanded ? Icon(Icons.expand_less) : Icon(Icons.expand_more))
                : null,
            onTap: isCurrentUserLeader && !isLeader ? onToggleExpand : null,
          ),
          if (isExpanded && isCurrentUserLeader && !isLeader)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
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