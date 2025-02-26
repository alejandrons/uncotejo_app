import 'package:flutter/material.dart';
import 'team_member_card.dart';
import 'package:uncotejo_front/shared/widgets/custom_widgets.dart';
import '/features/team_view/domain/user_mock.dart';

class TeamMemberList extends StatefulWidget {
  final bool isCurrentUserLeader;
  final List<User> teamMembers;
  final String loggedInUserName;
  final Function(int) onExpelMember;
  final Function(int) onTransferLeadership;

  const TeamMemberList({
    super.key,
    required this.isCurrentUserLeader,
    required this.teamMembers,
    required this.loggedInUserName,
    required this.onExpelMember,
    required this.onTransferLeadership,
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
              name: member.firstName,
              isLeader: member.role == 'team_leader',
              isCurrentUserLeader: widget.isCurrentUserLeader,
              loggedInUserName: widget.loggedInUserName,
              position: member.position, // Pass the position property
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