import 'package:flutter/material.dart';
import '../../../shared/widgets/home_screen.dart';
import '../../../shared/widgets/primary_button.dart';
import '../services/auth_services.dart';
import '../../../shared/widgets/input_field.dart';
import 'login_screen.dart';
import 'widgets/email_input.dart';
import 'widgets/password_input.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  String? _nameError;
  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;
  bool _isLoading = false;

  void _handleRegister() async {
    setState(() {
      _nameError =
          _nameController.text.isEmpty ? 'El nombre es obligatorio' : null;
      _emailError =
          _emailController.text.isEmpty ? 'El correo es obligatorio' : null;
      _passwordError = _passwordController.text.isEmpty
          ? 'La contraseña es obligatoria'
          : null;
      _confirmPasswordError =
          _confirmPasswordController.text != _passwordController.text
              ? 'Las contraseñas no coinciden'
              : null;
    });

    if (_nameError != null ||
        _emailError != null ||
        _passwordError != null ||
        _confirmPasswordError != null) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await AuthService.register(
        _nameController.text,
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
      appBar: AppBar(title: const Text('Registro')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomInputField(
                label: 'Nombre',
                controller: _nameController,
                onTap: () {},
                icon: Icons.person,
                readOnly: false,
                errorText: _nameError,
              ),
              const SizedBox(height: 16),
              EmailInputField(
                  controller: _emailController, errorText: _emailError),
              const SizedBox(height: 16),
              PasswordInputField(
                  controller: _passwordController, errorText: _passwordError),
              const SizedBox(height: 16),
              PasswordInputField(
                  controller: _passwordController, errorText: _passwordError),
              const SizedBox(height: 24),
              Center(
                child: Column(
                  children: [
                    _isLoading
                        ? const CircularProgressIndicator()
                        : PrimaryButton(
                            label: 'Registrarse',
                            onPressed: _handleRegister,
                            leftIcon: Icons.app_registration,
                          ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => LoginScreen()));
                      },
                      child: const Text('¿Ya tienes una cuenta? Inicia sesión'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
