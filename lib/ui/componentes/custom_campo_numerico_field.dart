import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomCampoNumericoField extends StatelessWidget {
  final TextEditingController controller;
  final bool required;
  final bool enabled;
  final String label;

  const CustomCampoNumericoField({super.key,
    required this.controller,
    this.required = false,
    this.enabled = false,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          '$label ${required ? '*' : ''}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        TextField(
          controller: controller,
          enabled: !enabled,
          keyboardType: TextInputType.number, // Define o teclado numérico
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')), // Aceita apenas números
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
