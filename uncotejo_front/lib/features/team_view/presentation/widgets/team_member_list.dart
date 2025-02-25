import 'package:flutter/material.dart';
import 'team_member_card.dart';
import 'package:uncotejo_front/shared/widgets/custom_widgets.dart';

class TeamMemberList extends StatefulWidget {
  final bool isCurrentUserLeader;
  final List<Map<String, dynamic>> teamMembers;
  final String loggedInUserName;

  const TeamMemberList({
    super.key,
    required this.isCurrentUserLeader,
    required this.teamMembers,
    required this.loggedInUserName,
  });

  @override
  _TeamMemberListState createState() => _TeamMemberListState();
}

class _TeamMemberListState extends State<TeamMemberList> {
  String? expandedMemberName;

  void _toggleExpand(String memberName) {
    setState(() {
      if (expandedMemberName == memberName) {
        expandedMemberName = null;
      } else {
        expandedMemberName = memberName;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.teamMembers.length,
      itemBuilder: (context, index) {
        final member = widget.teamMembers[index];
        return Column(
          children: [
            TeamMemberCard(
              name: member['name'],
              isLeader: member['isLeader'],
              isCurrentUserLeader: widget.isCurrentUserLeader,
              loggedInUserName: widget.loggedInUserName,
              onLeaderTransfer: member['onLeaderTransfer'],
              onExpel: member['onExpel'],
              isExpanded: expandedMemberName == member['name'],
              onToggleExpand: () => _toggleExpand(member['name']),
            ),
            const CustomSizedBox(height: 8),
          ],
        );
      },
    );
  }
}