import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:uncotejo_front/features/match/presentation/list_all_matches.dart';
import 'features/home/presentation/home_page.dart';
import 'features/match/aplication/match_provider.dart';
import 'features/match/presentation/create_match_page.dart';
import 'shared/utils/auth_mock.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();

  // Simular inicio de sesión antes de arrancar la app
  await AuthMock.login(dotenv.env['AUTH_EMAIL']!, dotenv.env['AUTH_PASSWORD']!);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MatchProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Uncotejo',
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/create-match': (context) => const CreateMatchPage(),
        '/list-matches': (context) => const MatchListScreen(),
      },
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
    );
  }
}
