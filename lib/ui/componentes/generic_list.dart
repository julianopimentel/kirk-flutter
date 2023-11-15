import 'package:flutter/material.dart';

class GenericList<T> extends StatelessWidget {
  final List<T> items;
  final String Function(T item) getName;
  final Function(T item) onTap;

  const GenericList({super.key,
    required this.items,
    required this.getName,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (BuildContext context, int index) {
        T item = items[index];
        return ListTile(
          title: Text(getName(item)),
          onTap: () => onTap(item),
        );
      },
    );
  }
}
