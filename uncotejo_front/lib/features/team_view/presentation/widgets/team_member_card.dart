import 'package:flutter/material.dart';
import 'package:uncotejo_front/shared/widgets/custom_widgets.dart';

class TeamMemberCard extends StatefulWidget {
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
  _TeamMemberCardState createState() => _TeamMemberCardState();
}

class _TeamMemberCardState extends State<TeamMemberCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          child: const Icon(Icons.person),
        ),
        title: Text(widget.name),
        subtitle: widget.isLeader ? const Text('Líder de equipo') : null,
        trailing: widget.isCurrentUserLeader
            ? widget.isLeader
                ? CustomTextButton(
                    onPressed: widget.onLeaderTransfer!,
                    text: 'Ceder puesto',
                    backgroundColor: Colors.lightGreen[100],
                    textColor: Colors.black,
                  )
                : CustomTextButton(
                    onPressed: widget.onExpel!,
                    text: 'Expulsar',
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                  )
            : null,
      ),
    );
  }
}