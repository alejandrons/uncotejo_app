import 'package:flutter/material.dart';
import 'team_member_card.dart';
import 'package:uncotejo_front/shared/widgets/custom_widgets.dart';

class TeamMemberList extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: teamMembers.length,
      itemBuilder: (context, index) {
        final member = teamMembers[index];
        return Column(
          children: [
            TeamMemberCard(
              name: member['name'],
              isLeader: member['isLeader'],
              isCurrentUserLeader: isCurrentUserLeader,
              loggedInUserName: loggedInUserName,
              onLeaderTransfer: member['onLeaderTransfer'],
              onExpel: member['onExpel'],
            ),
            const CustomSizedBox(height: 8),
          ],
        );
      },
    );
  }
}