import 'package:flutter/material.dart';

class CustomCampoField extends StatelessWidget {
  final TextEditingController controller;
  final bool required;
  final bool enabled;
  final String label;

  const CustomCampoField({super.key,
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
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

