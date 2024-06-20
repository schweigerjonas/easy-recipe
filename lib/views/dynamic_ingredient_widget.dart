import 'package:flutter/material.dart';

enum UnitLabel {
  select('-select-'),
  milliliter('ml'),
  liter('l'),
  gram('g'),
  kilogram('kg'),
  teaspoon('tsp'),
  tablespoon('tbsp');

  const UnitLabel(this.label);

  final String label;
}

class IngredientWidgetController {
  UnitLabel? selectedUnit = UnitLabel.select;
  final ingredientController = TextEditingController();
  final quantityController = TextEditingController();

  String getUnit() {
    String unit = "";
    if (selectedUnit != UnitLabel.select) unit = selectedUnit!.label;

    return unit;
  }
  String getIngredient() => ingredientController.text;
  String getQuantity() => quantityController.text;
}

class DynamicIngredientWidget extends StatefulWidget {
  final IngredientWidgetController controller;

  const DynamicIngredientWidget({super.key, required this.controller});

  @override
  State<DynamicIngredientWidget> createState() => _DynamicIngredientWidgetState();
}

class _DynamicIngredientWidgetState extends State<DynamicIngredientWidget> {

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Column(
      children: [
        Row(
          children: [
            SizedBox(
              width: ((size.width / 32) * 5),
              child: TextField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                controller: widget.controller.quantityController,
              ),
            ),
            SizedBox(width: size.width / 64),
            SizedBox(
              width: ((size.width / 32) * 7),
              child: DropdownButtonFormField<UnitLabel>(
                isDense: true,
                value: widget.controller.selectedUnit,
                onChanged: (UnitLabel? value) {
                  setState(() {
                    widget.controller.selectedUnit = value;
                  });
                },
                items: UnitLabel.values
                    .map<DropdownMenuItem<UnitLabel>>((UnitLabel? unit) {
                  return DropdownMenuItem<UnitLabel>(
                    value: unit,
                    child: Text(unit!.label),
                  );
                }).toList(),
              ),
            ),
            SizedBox(width: size.width / 64),
            SizedBox(
              width: ((size.width / 8) * 4),
              child: TextField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                controller: widget.controller.ingredientController,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8.0),
      ],
    );
  }
}
