import 'user_mock.dart'; // Importar la clase User

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
  final DateTime createdAt;
  final DateTime updatedAt;
  final User? teamLeader;
  final List<User> players;

  Team({
    required this.id,
    required this.name,
    required this.description,
    required this.slogan,
    required this.linkAccess,
    this.colorPrimary,
    this.colorSecondary,
    required this.shieldForm,
    this.shieldInterior,
    required this.teamLeaderId,
    required this.teamType,
    required this.createdAt,
    required this.updatedAt,
    this.teamLeader,
    required this.players,
  });

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      slogan: json['slogan'] ?? '',
      linkAccess: json['linkAccess'] ?? '',
      colorPrimary: json['colorPrimary'] as String?,
      colorSecondary: json['colorSecondary'] as String?,
      shieldForm: json['shieldForm'] ?? 'default.png',
      shieldInterior: json['shieldInterior'] as String?,
      teamType: json['teamType'] ?? '',
      teamLeaderId: json['teamLeaderId'] is int
          ? json['teamLeaderId']
          : int.tryParse(json['teamLeaderId'].toString()) ?? 0,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      teamLeader: json['teamLeader'] != null
          ? User.fromJson(json['teamLeader'] as Map<String, dynamic>)
          : null,
      players: json['players'] != null
          ? (json['players'] as List)
              .map((player) => User.fromJson(player as Map<String, dynamic>))
              .toList()
          : [],
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
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'teamLeader': teamLeader?.toJson(),
      'players': players.map((player) => player.toJson()).toList(),
    };
  }
}
