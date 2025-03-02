import 'package:flutter/material.dart';
import 'team_member_card.dart';
import 'package:uncotejo_front/shared/widgets/custom_widgets.dart';
import '/features/team/domain/user_mock.dart';

class TeamMemberList extends StatefulWidget {
  final bool isCurrentUserLeader;
  final List<User> teamMembers;
  final Function(int) onExpelMember;
  final Function(int) onTransferLeadership;
  final VoidCallback onRefreshTeam;

  const TeamMemberList({
    super.key,
    required this.isCurrentUserLeader,
    required this.teamMembers,
    required this.onExpelMember,
    required this.onTransferLeadership,
    required this.onRefreshTeam,
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
              name: member.name,
              isLeader: member.role == 'team_leader',
              isCurrentUserLeader: widget.isCurrentUserLeader,
              position: member.position,
              onLeaderTransfer: () => widget.onTransferLeadership(member.id),
              onExpel: () => widget.onExpelMember(member.id),
              isExpanded: expandedMemberName == member.name,
              onToggleExpand: () => _toggleExpand(member.name),
            ),
            const CustomSizedBox(height: 8),
          ],
        );
      },
    );
  }
}