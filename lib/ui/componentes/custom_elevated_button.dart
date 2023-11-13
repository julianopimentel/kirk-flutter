import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label; // Adicione esta propriedade

  CustomElevatedButton({
    required this.onPressed,
    required this.label, // Inclua esta propriedade
  });

  @override
  Widget build(BuildContext context) {
   return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: Size(150, 50), // Define o tamanho mínimo do botão
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 16, // Tamanho da fonte aumentado
          fontWeight: FontWeight.w800,
          color: Colors.white,
        ),
      ),
    );
  }
}
