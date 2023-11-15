import 'package:flutter/material.dart';

class EmailField extends StatelessWidget {
  final TextEditingController controller;
  final bool required;
  final bool enabled;

  const EmailField({super.key,
    required this.controller,
    this.required = false,
    this.enabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Email ${required ? '*' : ''}',
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

