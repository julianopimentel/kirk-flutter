import 'package:flutter/material.dart';

class NomeField extends StatelessWidget {
  final TextEditingController controller;
  final bool required;
  final bool enabled;
  final ValueChanged<String>? onValueChanged; // Adicione esta linha

  const NomeField({super.key,
    required this.controller,
    this.required = false,
    this.enabled = false,
    this.onValueChanged,
  });



  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Nome ${required ? '*' : ''}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        TextField(
          controller: controller,
          enabled: !enabled,
          onChanged: (value) {
            if (onValueChanged != null) {
              onValueChanged!(value);
            }
          },
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

