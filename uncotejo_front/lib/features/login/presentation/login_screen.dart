import 'package:flutter/material.dart';
import '../../../shared/widgets/home_screen.dart';
import '../../../shared/widgets/primary_button.dart';
import '../services/auth_services.dart';
import 'register_screen.dart';
import 'widgets/email_input.dart';
import 'widgets/password_input.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? _emailError;
  String? _passwordError;
  bool _isLoading = false;

  void _handleLogin() async {
    setState(() {
      _emailError =
          _emailController.text.isEmpty ? 'El correo es obligatorio' : null;
      _passwordError = _passwordController.text.isEmpty
          ? 'La contraseña es obligatoria'
          : null;
    });

    if (_emailError != null || _passwordError != null) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await AuthService.login(
        _emailController.text,
        _passwordController.text,
        context: context,
      );
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => HomeScreen(),
      ));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              EmailInputField(
                  controller: _emailController, errorText: _emailError),
              const SizedBox(height: 16),
              PasswordInputField(
                  controller: _passwordController, errorText: _passwordError),
              const SizedBox(height: 24),
              Center(
                child: Column(children: [
                  _isLoading
                      ? const CircularProgressIndicator()
                      : PrimaryButton(
                          label: 'Iniciar sesión',
                          onPressed: _handleLogin,
                          leftIcon: Icons.login,
                        ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => RegisterScreen()));
                    },
                    child: const Text('¿No te has registrado? Regístrate aquí'),
                  ),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
