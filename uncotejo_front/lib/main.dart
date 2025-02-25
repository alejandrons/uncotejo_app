import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:uncotejo_front/shared/widgets/home_screen.dart';
import 'shared/utils/auth_mock.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();

  // Simular inicio de sesión antes de arrancar la app
  //await AuthMock.logout();
  await AuthMock.login(dotenv.env['AUTH_EMAIL']!, dotenv.env['AUTH_PASSWORD']!);


  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'UnCotejo',

      home: const HomeScreen(), // Usamos MainScreen como Home

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
    );
  }
}
