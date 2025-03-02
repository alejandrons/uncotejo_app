import 'package:flutter/material.dart';

class EmailInputField extends StatelessWidget {
  final TextEditingController controller;
  final String? errorText;

  const EmailInputField({super.key, required this.controller, this.errorText});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: 'Correo Electrónico',
            hintText: 'ejemplo@correo.com',
            prefixIcon: const Icon(Icons.email),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            errorText: errorText,
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
