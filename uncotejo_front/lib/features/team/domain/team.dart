import 'user_mock.dart'; // Add this line to import the User class

class Team {
  final int id;
  final String name;
  final String description;
  final String slogan;
  final String linkAccess;
  final String? colorPrimary;
  final String? colorSecondary;
  final String shieldForm;
  final String? shieldInterior;

  final String teamType;
  final int teamLeaderId;

  final List<User>? players;

  Team({
    required this.id,
    required this.name,
    required this.description,
    required this.slogan,
    required this.linkAccess,
    required this.colorPrimary,
    required this.colorSecondary,
    required this.shieldForm,
    required this.shieldInterior,
    required this.teamLeaderId,
    required this.teamType,
    required this.players,
  });

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      slogan: json['slogan'] ?? '',
      linkAccess: json['linkAccess'] ?? '',
      colorPrimary: json['colorPrimary'] ?? '',
      colorSecondary: json['colorSecondary'] ?? '',
      shieldForm: json['shieldForm'] ?? '',
      shieldInterior: json['shieldInterior'] ?? '',
      teamType: json['teamType'] ?? '',
      teamLeaderId: json['teamLeaderId'] ?? '',
      players: (json['players'] as List)
          .map((player) => User.fromJson(player))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'slogan': slogan,
      'linkAccess': linkAccess,
      'colorPrimary': colorPrimary,
      'colorSecondary': colorSecondary,
      'shieldForm': shieldForm,
      'shieldInterior': shieldInterior,
      'teamType': teamType,
      'teamLeaderId': teamLeaderId,
      'players': players?.map((player) => player.toJson()).toList(),
    };
  }
}
