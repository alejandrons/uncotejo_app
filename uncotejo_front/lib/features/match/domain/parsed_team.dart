class ParsedTeam {
  final int id;
  final String name;
  final String linkAccess;
  final String? colorPrimary;
  final String? colorSecondary;
  final String shieldForm;
  final String? shieldInterior;
  final int teamLeaderId;

  ParsedTeam({
    required this.id,
    required this.name,
    required this.linkAccess,
    required this.colorPrimary,
    required this.colorSecondary,
    required this.shieldForm,
    required this.shieldInterior,
    required this.teamLeaderId,
  });

  factory ParsedTeam.fromJson(Map<String, dynamic> json) {
    return ParsedTeam(
      id: json['id'],
      name: json['name'],
      linkAccess: json['linkAccess'],
      colorPrimary: json['colorPrimary'],
      colorSecondary: json['colorSecondary'],
      shieldForm: json['shieldForm'],
      shieldInterior: json['shieldInterior'],
      teamLeaderId: json['teamLeaderId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'linkAccess': linkAccess,
      'colorPrimary': colorPrimary,
      'colorSecondary': colorSecondary,
      'shieldForm': shieldForm,
      'shieldInterior': shieldInterior,
      'teamLeaderId': teamLeaderId,
    };
  }
}
