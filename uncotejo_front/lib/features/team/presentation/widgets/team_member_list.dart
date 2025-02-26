import 'package:flutter/material.dart';
import 'team_member_card.dart';
import 'package:uncotejo_front/shared/widgets/custom_widgets.dart';
import '/features/team/domain/user_mock.dart';

class TeamMemberList extends StatefulWidget {
  final bool isCurrentUserLeader;
  final List<User> teamMembers;
  final String loggedInUserName;
  final Function(int) onExpelMember;
  final Function(int) onTransferLeadership;
  final VoidCallback onRefreshTeam; // Add the refresh callback

  const TeamMemberList({
    super.key,
    required this.isCurrentUserLeader,
    required this.teamMembers,
    required this.loggedInUserName,
    required this.onExpelMember,
    required this.onTransferLeadership,
    required this.onRefreshTeam, // Add the refresh callback
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
              name: '${member.firstName} ${member.lastName}',
              isLeader: member.role == 'team_leader',
              isCurrentUserLeader: widget.isCurrentUserLeader,
              loggedInUserName: widget.loggedInUserName,
              position: member.position,
              onLeaderTransfer: () => widget.onTransferLeadership(member.id),
              onExpel: () => widget.onExpelMember(member.id),
              isExpanded: expandedMemberName == member.firstName,
              onToggleExpand: () => _toggleExpand(member.firstName),
            ),
            const CustomSizedBox(height: 8),
          ],
        );
      },
    );
  }
}