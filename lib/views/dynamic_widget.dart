import 'package:flutter/material.dart';

enum UnitLabel {
  select('-select a unit-'),
  milliliter('ml'),
  liter('l'),
  gram('g'),
  kilogram('kg'),
  teaspoon('tsp'),
  tablespoon('tbsp');

  const UnitLabel(this.label);

  final String label;
}

class DynamicWidget extends StatelessWidget {
  DynamicWidget({super.key});

  final controller = TextEditingController();
  UnitLabel? selectedUnit = UnitLabel.select;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 16.0),
      child: Row(
        children: [
          TextField(
            controller: controller,
          ),
          DropdownMenu<UnitLabel>(
            initialSelection: UnitLabel.select,
            onSelected: (UnitLabel? unit) {
              selectedUnit = unit;
            },
            dropdownMenuEntries: UnitLabel.values
                .map<DropdownMenuEntry<UnitLabel>>((UnitLabel unit) {
              return DropdownMenuEntry<UnitLabel>(
                value: unit,
                label: unit.label,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}