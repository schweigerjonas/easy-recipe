import 'package:flutter/material.dart';

import 'dynamic_widget.dart';

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

class CreateRecipePage extends StatefulWidget {
  const CreateRecipePage({super.key});

  @override
  State<CreateRecipePage> createState() => _CreateRecipePageState();
}

class _CreateRecipePageState extends State<CreateRecipePage> {
  UnitLabel? selectedUnit;
  final recipeNameController = TextEditingController();
  final portionController = TextEditingController();

  List<DynamicWidget> dynamicTextFields = [];
  List<String> ingredientsData = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Text('Create Recipe',
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: 20.0,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 16.0),
              child: ListView(
                shrinkWrap: true,
                children: <Widget>[
                  const SizedBox(height: 16.0),
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Recipe Name',
                    ),
                    controller: recipeNameController,
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    children: <Widget>[
                      const Text('The recipe is designed for '),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: TextField(
                            decoration: const InputDecoration(
                              labelText: 'Portions',
                            ),
                            controller: portionController,
                          ),
                        ),
                      ),
                      const Text(' persons/portions.'),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  const Text('Ingredients and quantities'),
                  const SizedBox(height: 16.0),
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
