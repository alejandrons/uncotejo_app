import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uncotejo_front/features/home/presentation/widgets/create_team_screen.dart';
import '../../match/services/match_repository.dart';
import '../../match/domain/match.dart' as custom_match;
import '../../../shared/widgets/secondary_button.dart';
import '../../../shared/widgets/template_card.dart';
import '../../../shared/widgets/top_navigation.dart';

class HomeTeamPage extends StatefulWidget {
  const HomeTeamPage({super.key});

  @override
  _HomeTeamPage createState() => _HomeTeamPage();
}

class _HomeTeamPage extends State<HomeTeamPage> {
  late Future<List<custom_match.Match>> _matchesFuture;

  @override
  void initState() {
    super.initState();
    _matchesFuture = MatchRepository.getMatchesForUserTeam();
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
        title: 'Mis partidos de equipo',
        leadingIcon: Icons.group_add,
        onLeadingPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateTeamScreen()),
          );
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Expanded(
              child: FutureBuilder<List<custom_match.Match>>(
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
                              "text": match.possibleDates.days?.join(", ") ??
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
