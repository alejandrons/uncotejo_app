import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../domain/match.dart';
import 'create_match_page.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../../shared/widgets/secondary_button.dart';
import '../../../shared/widgets/template_card.dart';
import '../../../shared/widgets/top_navigation.dart';
import '../services/match_repository.dart';

class MatchListPage extends StatefulWidget {
  const MatchListPage({super.key});

  @override
  _MatchListPageState createState() => _MatchListPageState();
}

class _MatchListPageState extends State<MatchListPage> {
  late Future<List<Match>> _matchesFuture;

  @override
  void initState() {
    super.initState();
    _matchesFuture = MatchRepository.getAllMatches();
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
      final match = await MatchRepository.makeMatchByLink(
          link, selectedTime, possibleDates);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Partido contra: ${match.homeTeam?.name}  pactado con éxito')),
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
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Lista de equipos en búsqueda de partidos',
        leadingIcon: Icons.group_add,
        onLeadingPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateMatchPage()),
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
                future: _matchesFuture,
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

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: TemplateCard(
                          title: "vs $homeTeamName",
                          attributes: [
                            {
                              "text": match.possibleDates.days?.join(", ") ??
                                  "Fechas no disponibles",
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
                                  _pickTimeAndMakeMatch(context,
                                      match); // Abrir modal de selección de hora
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
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
  }
}
