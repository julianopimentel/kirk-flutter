import 'package:flutter/material.dart';

class DataField extends StatefulWidget {
  final DateTime? selectedDate;
  final Function(DateTime)? onDataSelect;
  final bool enabled;
  final String? label;

  const DataField({super.key,
    required this.selectedDate,
    this.onDataSelect,
    this.enabled = true,
    this.label,
  });

  @override
  createState() => _DataFieldState();
}

class _DataFieldState extends State<DataField> {
  Future<void> _showDatePicker(BuildContext context) async {
    if (!widget.enabled) return; // Verifique se o campo está habilitado

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != widget.selectedDate) {
      widget.onDataSelect!(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          widget.label ?? 'Data',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 7),
        InputDecorator(
          decoration: const InputDecoration(
            border: InputBorder.none,
          ),
          child: GestureDetector(
            onTap: () {
              if (!widget.enabled) return; // Verifique se o campo está habilitado
              _showDatePicker(context);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 12.0,
              ),
              child: Text(
                widget.enabled
                    ? (widget.selectedDate != null
                    ? '${widget.selectedDate!.day}/${widget.selectedDate!.month}/${widget.selectedDate!.year}'
                    : 'Selecione a data')
                    : '${widget.selectedDate!.day}/${widget.selectedDate!.month}/${widget.selectedDate!.year}',
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
