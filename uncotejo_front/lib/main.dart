//import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'features/login/presentation/login_screen.dart';
import 'features/match/aplication/match_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //await Firebase.initializeApp();
  await dotenv.load();
  
  // Simular inicio de sesión antes de arrancar la app
  //await AuthMock.login(dotenv.env['AUTH_EMAIL']!, dotenv.env['AUTH_PASSWORD']!);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MatchProvider()),
      ],
      child: const MyApp(),
    ),
  );
}
final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Uncotejo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightGreen),
        primarySwatch: Colors.lightGreen,
        useMaterial3: true,
      ),
      scaffoldMessengerKey: scaffoldMessengerKey,

      home: const LoginScreen(),
    );
  }
}
