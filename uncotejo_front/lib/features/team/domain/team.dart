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
  final int teamLeaderId;
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
    this.teamLeader,
    required this.players,
  });

  factory Team.fromJson(Map<String, dynamic> json) {

  return Team(
    id: json['id'],
    name: json['name'] ,
    description: json['description'],
    slogan: json['slogan'] ,
    linkAccess: json['linkAccess'],
    shieldForm: json['shieldForm'],
    teamLeaderId: json['teamLeaderId'],

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
      'teamLeaderId': teamLeaderId,
      'teamLeader': teamLeader?.toJson(),
      'players': players.map((player) => player.toJson()).toList(),
    };
  }
}
