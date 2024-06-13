import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/creation_model.dart';

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

class SetRecipeIngredients extends StatefulWidget {
  const SetRecipeIngredients({super.key});

  @override
  State<SetRecipeIngredients> createState() => _SetRecipeIngredientsState();
}

class _SetRecipeIngredientsState extends State<SetRecipeIngredients> {
  UnitLabel? selectedUnit;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Test'),
        DropdownMenu<UnitLabel>(
          initialSelection: UnitLabel.select,
          onSelected: (UnitLabel? unit) {
            setState(() {
              selectedUnit = unit;
            });
          },
          dropdownMenuEntries: UnitLabel.values
              .map<DropdownMenuEntry<UnitLabel>>((UnitLabel unit) {
            return DropdownMenuEntry<UnitLabel>(
              value: unit,
              label: unit.label,
            );
          }).toList(),
        ),
        ElevatedButton(
          onPressed: () {
            Provider.of<CreationModel>(context, listen: false).setPageIndex(0);
          },
          child: const Text('Back'),
        ),
      ],
    );
  }
}