import 'package:flutter/material.dart';

class TelefoneField extends StatelessWidget {
  final TextEditingController controller;
  final bool obrigatorio;
  final bool enabled;
  final ValueChanged<String>? onValueChanged; // Adicione esta linha

  TelefoneField({
    required this.controller,
    this.obrigatorio = false,
    this.enabled = false,
    this.onValueChanged,
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
          onChanged: (value) {
            if (onValueChanged != null) {
              onValueChanged!(value);
            }
          },
        ),
        SizedBox(height: 20),
      ],
    );
  }
}

