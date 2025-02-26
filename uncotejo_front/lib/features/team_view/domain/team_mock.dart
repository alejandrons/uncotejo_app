import 'user_mock.dart'; // Add this line to import the User class

class Team {
  final int id;
  final String teamName;
  final String description;
  final String slogan;
  final String linkAccess;
  final String shieldForm;
  final String teamType;
  final List<User> players;

  Team({
    required this.id,
    required this.teamName,
    required this.description,
    required this.slogan,
    required this.linkAccess,
    required this.shieldForm,
    required this.teamType,
    required this.players,
  });

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      id: json['id'] ?? 0,
      teamName: json['name'] ?? '',
      description: json['description'] ?? '',
      slogan: json['slogan'] ?? '',
      linkAccess: json['linkAccess'] ?? '',
      shieldForm: json['shieldForm'] ?? '',
      teamType: json['teamType'] ?? '',
      players: (json['players'] as List).map((player) => User.fromJson(player)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': teamName,
      'description': description,
      'slogan': slogan,
      'linkAccess': linkAccess,
      'shieldForm': shieldForm,
      'teamType': teamType,
      'players': players.map((player) => player.toJson()).toList(),
    };
  }
}