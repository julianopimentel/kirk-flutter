import 'package:flutter/material.dart';

class DropdownField extends StatelessWidget {
  final DropdownItem? selectedValue;
  final List<DropdownItem> items;
  final Function(DropdownItem?) onChanged;
  final String label;
  final bool required;
  final bool disabled;

  const DropdownField({super.key,
    required this.label,
    required this.selectedValue,
    required this.items,
    required this.onChanged,
    this.required = false,
    this.disabled = false,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label + (required == true ? '*' : ''),
          style: const TextStyle(fontWeight: FontWeight.bold),
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
                enabled: !disabled,
                child: Text(item.title),
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
