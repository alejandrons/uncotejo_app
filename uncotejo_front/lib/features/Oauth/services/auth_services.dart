// import 'package:flutter/material.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import '../../../shared/exceptions/exception_controller.dart';
// import '../../../shared/utils/http_client.dart';

// class AuthService {
//   static const String _authEndpoint = "/user";
//   static final String baseUrl = _tokenKey.isNotEmpty
//       ? _tokenKey
//       : throw Exception("AUTH_TOKEN_KEY no definida en .env");

//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final GoogleSignIn _googleSignIn = GoogleSignIn();

//   // Google Sign-In
//   Future<void> handleSignIn(BuildContext context) async {
//     try {
//       final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
//       if (googleUser == null) {
//         throw Exception("Inicio de sesión cancelado por el usuario.");
//       }

//       final GoogleSignInAuthentication googleAuth =
//           await googleUser.authentication;
//       final AuthCredential credential = GoogleAuthProvider.credential(
//         accessToken: googleAuth.accessToken,
//         idToken: googleAuth.idToken,
//       );

//       await _auth.signInWithCredential(credential);

//       final User? user = _auth.currentUser;
//       if (user == null) {
//         throw Exception("No se pudo obtener información del usuario.");
//       }

//       final response = await HttpClient.post(
//         "$_authEndpoint/login",
//         {
//           "name": user.displayName ?? "Usuario sin nombre",
//           "email": user.email ?? "correo_no_disponible",
//         },
//       );
//       print("response: $response");

//       if (response.containsKey("token")) {
//         await saveToken(response["token"]);
//       }

//     } catch (error) {
//       ExceptionController.handleException( error);
//     }
//   }

//   // Google Sign-Out
//   Future<void> handleSignOut(BuildContext context) async {
//     try {
//       await _googleSignIn.signOut();
//       await _auth.signOut();
//       await removeToken();
//     } catch (error) {
//       ExceptionController.handleException( error);
//     }
//   }
// }
