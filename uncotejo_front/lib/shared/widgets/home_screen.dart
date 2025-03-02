import 'package:flutter/material.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:uncotejo_front/features/home/presentation/widgets/search_team_screen.dart';
import 'package:uncotejo_front/features/team/presentation/team_screen.dart';
import 'package:uncotejo_front/features/team/services/team_repository.dart';
import 'package:uncotejo_front/shared/utils/token_service.dart';
import '../../features/home/presentation/home_team_page.dart';
import '../../features/login/services/auth_services.dart';
import '../../features/match/presentation/list_all_matches.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  late Future<bool> _isUserInTeam;
  late List<Widget Function()> _screens;

  @override
  void initState() {
    super.initState();
    _isUserInTeam = _checkUserTeamStatus();
  }

  Future<bool> _checkUserTeamStatus() async {
    String? token =
        await TokenService.getToken(); 
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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
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

        _screens = [
          () => isUserInTeam ? const HomeTeamPage() : const SearchTeamScreen(),
          () => TeamScreen(onLeaveTeam: () => _onItemTapped(0)),
          () => const MatchListPage(),
          () => const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Eventos",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Coming Soon",
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
        ];

        return Scaffold(
          body: _screens[_selectedIndex](),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Inicio',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.sports_soccer),
                label: 'Equipo',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.sports),
                label: 'Partidos',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.emoji_events),
                label: 'Eventos',
              ),
            ],
          ),
        );
      },
    );
  }
}
