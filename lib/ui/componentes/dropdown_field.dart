import 'package:flutter/material.dart';

class DropdownField extends StatelessWidget {
  final DropdownItem? selectedValue;
  final List<DropdownItem> items;
  final Function(DropdownItem?) onChanged;
  final String label;
  final bool obrigatorio;
  final bool desabilitado;

  DropdownField({
    required this.label,
    required this.selectedValue,
    required this.items,
    required this.onChanged,
    this.obrigatorio = false,
    this.desabilitado = false,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label + (obrigatorio == true ? '*' : ''),
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        InputDecorator(
          decoration: const InputDecoration(
            border: InputBorder.none,
            //labelText: 'Selecione uma opção',
          ),
          child: DropdownButton<DropdownItem>(
            isExpanded: true,
            value: selectedValue,
            items: items.map((DropdownItem item) {
              return DropdownMenuItem<DropdownItem>(
                value: item,
                child: Text(item.title),
                enabled: !desabilitado,
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

class DropdownItem {
  final String value;
  final String title;

  DropdownItem({required this.value, required this.title});
}
