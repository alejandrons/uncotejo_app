import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/auth_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;

    return Scaffold(
      // backgroundColor: Theme.of(context).primaryColor.withOpacity(0.9),
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor.withOpacity(0.9),
        // title: const Text('Home'),
        title: Text(
            'Bienvenido ${firebaseAuth.currentUser?.displayName ?? 'Home'}'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                authService.handleSignOut();
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => const AuthScreen(),
                //   ),
                // );
              })
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CachedNetworkImage(
              imageUrl: firebaseAuth.currentUser!.photoURL!,
              placeholder: (_, __) => CircularProgressIndicator(),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              firebaseAuth.currentUser?.email ?? 'No data',
              style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            Text(
              firebaseAuth.currentUser?.displayName ?? 'No data',
              style: TextStyle(
                color: Colors.grey[800],
                decorationStyle: TextDecorationStyle.solid,
                fontSize: 18,
              ),
            ),

            // Text(firebaseAuth.currentUser?.displayName ?? 'No data'),
            // Text(firebaseAuth.currentUser?.email ?? 'No data'),
          ],
        ),
      ),
    );
  }
}
