import 'package:flutter/material.dart';

class TelefoneField extends StatelessWidget {
  final TextEditingController controller;
  final bool obrigatorio;
  final bool enabled;

  TelefoneField({
    required this.controller,
    this.obrigatorio = false,
    this.enabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Telefone ${obrigatorio ? '*' : ''}',
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

