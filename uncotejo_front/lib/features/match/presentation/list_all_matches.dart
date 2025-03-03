import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../domain/match.dart';
import 'create_match_page.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../../shared/widgets/secondary_button.dart';
import '../../../shared/widgets/template_card.dart';
import '../../../shared/widgets/top_navigation.dart';
import '../services/match_repository.dart';
import '../../login/services/auth_services.dart';
import '../../../shared/utils/token_service.dart';
import 'package:jwt_decode/jwt_decode.dart';

class MatchListPage extends StatefulWidget {
  const MatchListPage({super.key});

  @override
  _MatchListPageState createState() => _MatchListPageState();
}

class _MatchListPageState extends State<MatchListPage> {
  late Future<bool> _isUserInTeam;
  // ignore: unused_field
  late Future<List<Match>> _matchesFuture;

  @override
  void initState() {
    super.initState();
    _isUserInTeam = _checkUserTeamStatus();
  }

  Future<bool> _checkUserTeamStatus() async {
    String? token = await TokenService.getToken();
    if (token == null) {
      return false;
    }

    Map<String, dynamic> decodedToken = Jwt.parseJwt(token);
    final int? userId = decodedToken["id"];

    if (userId == null) {
      return false;
    }

    return await AuthService.isUserInTeam(userId);
  }

  Future<void> _pickTimeAndMakeMatch(BuildContext context, Match match) async {
    final TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: match.fixedTime,
    );

    if (selectedTime != null) {
      _makeMatch(match.link!, selectedTime, match.possibleDates.toJson());
    }
  }

  void _makeMatch(String link, TimeOfDay selectedTime,
      Map<String, dynamic> possibleDates) async {
    try {
      await MatchRepository.makeMatchByLink(
          link, selectedTime, possibleDates);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Partido pactado con éxito')),
      );
      setState(() {
        _matchesFuture = MatchRepository.getAllMatches();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al pactar el partido: $e')),
      );
    }
  }

  void _copyLink(String? link) {
    if (link != null && link.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: link));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Link copiado al portapapeles')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No hay un link disponible para copiar')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _isUserInTeam,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final bool isUserInTeam = snapshot.data ?? false;

        if (!isUserInTeam) {
          return Scaffold(
            appBar: CustomAppBar(
              title: 'Partidos Disponibles',
            ),
            body: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.groups,
                    size: 80,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 20),
                  Text(
                    "No perteneces a un equipo",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Únete a un equipo o crea uno para participar en partidos.",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          );
        }

        return Scaffold(
          appBar: CustomAppBar(
            title: 'Equipos buscando partidos',
            leadingIcon: Icons.group_add,
            onLeadingPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const CreateMatchPage()),
              );
            },
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const SizedBox(height: 10),
                Expanded(
                  child: FutureBuilder<List<Match>>(
                    future: MatchRepository.getAllMatches(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text("Error: ${snapshot.error}"));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(
                            child: Text("No hay partidos disponibles"));
                      }

                      final matches = snapshot.data!;

                      return ListView.builder(
                        itemCount: matches.length,
                        itemBuilder: (context, index) {
                          final match = matches[index];
                          final String homeTeamName =
                              match.homeTeam?.name ?? "Equipo desconocido";

                          final String? shieldImageName =
                              match.homeTeam?.shieldForm;
                          final String? shieldImageUrl = shieldImageName != null
                              ? 'assets/shields/$shieldImageName'
                              : null;

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: TemplateCard(
                              title: "vs $homeTeamName",
                              imageUrl: shieldImageUrl,
                              attributes: [
                                {
                                  "text": match.possibleDates.days
                                          ?.join(", ") ??
                                      "${match.possibleDates.from} ${match.possibleDates.to}",
                                  "icon": Icons.calendar_today
                                },
                                {
                                  "text":
                                      "Hora: ${match.fixedTime.hour.toString().padLeft(2, '0')}:${match.fixedTime.minute.toString().padLeft(2, '0')}",
                                  "icon": Icons.access_time
                                },
                              ],
                              buttons: [
                                PrimaryButton(
                                  label: "Pactar partido",
                                  color: Colors.grey[600],
                                  onPressed: () {
                                    if (match.link != null) {
                                      _pickTimeAndMakeMatch(context, match);
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                "No se puede pactar este partido")),
                                      );
                                    }
                                  },
                                ),
                                SecondaryButton(
                                  label: "Copiar link del Partido",
                                  leftIcon: Icons.copy,
                                  onPressed: () {
                                    _copyLink(match.link);
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
