class User {
  final int id;
  final String firstName;
  final String lastName;
  final String role;
  final String? position; // Allow position to be null
  final int teamId;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.role,
    this.position, // Allow position to be null
    required this.teamId,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      role: json['role'],
      position: json['position'], // Allow position to be null
      teamId: json['teamId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'role': role,
      'position': position,
      'teamId': teamId,
    };
  }
}