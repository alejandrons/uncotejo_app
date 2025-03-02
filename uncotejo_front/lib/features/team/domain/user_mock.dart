class User {
  final int id;
  final String name;
  final String role;
  final String? position;
  final int teamId;

  User({
    required this.id,
    required this.name,
    required this.role,
    this.position,
    required this.teamId,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      role: json['role'],
      position: json['position'],
      teamId: json['teamId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'role': role,
      'position': position,
      'teamId': teamId,
    };
  }
}
