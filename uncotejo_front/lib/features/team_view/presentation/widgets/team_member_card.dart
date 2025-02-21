import 'package:flutter/material.dart';
import 'package:uncotejo_front/shared/widgets/custom_widgets.dart';

class TeamMemberCard extends StatefulWidget {
  final String name;
  final bool isLeader;
  final bool isCurrentUserLeader;
  final String loggedInUserName;
  final VoidCallback? onLeaderTransfer;
  final VoidCallback? onExpel;

  const TeamMemberCard({
    super.key,
    required this.name,
    this.isLeader = false,
    required this.isCurrentUserLeader,
    required this.loggedInUserName,
    this.onLeaderTransfer,
    this.onExpel,
  });

  @override
  _TeamMemberCardState createState() => _TeamMemberCardState();
}

class _TeamMemberCardState extends State<TeamMemberCard> {
  bool _isExpanded = false;

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isLoggedInUser = widget.name == widget.loggedInUserName;

    return Card(
      color: isLoggedInUser ? Colors.blue[50] : null, // Highlight the card if it belongs to the logged-in user
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              child: const Icon(Icons.person),
            ),
            title: Text(widget.name),
            subtitle: widget.isLeader ? const Text('Líder de equipo') : null,
            trailing: widget.isCurrentUserLeader && !widget.isLeader
                ? (_isExpanded ? Icon(Icons.expand_less) : Icon(Icons.expand_more))
                : null,
            onTap: widget.isCurrentUserLeader && !widget.isLeader ? _toggleExpand : null,
          ),
          if (_isExpanded && widget.isCurrentUserLeader && !widget.isLeader)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (widget.onLeaderTransfer != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: CustomTextButton(
                        onPressed: widget.onLeaderTransfer!,
                        text: 'Ceder puesto',
                        backgroundColor: Colors.lightGreen[100],
                        textColor: Colors.black,
                      ),
                    ),
                  const SizedBox(height: 8),
                  if (widget.onExpel != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: CustomTextButton(
                        onPressed: widget.onExpel!,
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