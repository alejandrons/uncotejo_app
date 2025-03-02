// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:uncotejo_front/features/auth/presentation/widgets/auth_screen.dart';
// import 'package:uncotejo_front/shared/widgets/home_screen.dart';

// class AuthPage extends StatefulWidget {
//   const AuthPage({super.key});

//   @override
//   State<AuthPage> createState() => _AuthPageState();
// }

// class _AuthPageState extends State<AuthPage> {
//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: StreamBuilder<User?>(
//         stream: FirebaseAuth.instance.authStateChanges(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             Center(
//                 child: CircularProgressIndicator(
//                     valueColor: AlwaysStoppedAnimation<Color>(
//               Theme.of(context).primaryColor,
//             )));
//           }
//           if (snapshot.hasData) {
//             return const HomeScreen();
//           } else {
//             return const AuthScreen();
//           }
//         },
//       ),
//     );
//   }
// }