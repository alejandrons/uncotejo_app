class Team {
  final int id;
  final String name;
  final String slogan;
  final String shieldForm;

  Team({
    required this.id,
    required this.name,
    required this.slogan,
    required this.shieldForm,
  });

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      id: json['id'],
      name: json['name'],
      slogan: json['slogan'],
      shieldForm: json['shieldForm'],
    );
  }
}