import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomCampoNumericoField extends StatelessWidget {
  final TextEditingController controller;
  final bool obrigatorio;
  final bool enabled;
  final String label;

  CustomCampoNumericoField({
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
          keyboardType: TextInputType.number, // Define o teclado numérico
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')), // Aceita apenas números
          ],
        ),
        SizedBox(height: 20),
      ],
    );
  }
}
