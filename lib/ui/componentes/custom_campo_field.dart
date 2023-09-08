import 'package:flutter/material.dart';

class CustomCampoField extends StatelessWidget {
  final TextEditingController controller;
  final bool obrigatorio;
  final bool enabled;
  final String label;

  CustomCampoField({
    required this.controller,
    this.obrigatorio = false,
    this.enabled = false,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          '$label ${obrigatorio ? '*' : ''}',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        TextField(
          controller: controller,
          enabled: !enabled,
        ),
        SizedBox(height: 20),
      ],
    );
  }
}

