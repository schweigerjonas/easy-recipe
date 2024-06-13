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

class DynamicWidget extends StatefulWidget {
  const DynamicWidget({super.key});

  @override
  State<DynamicWidget> createState() => _DynamicWidgetState();
}

class _DynamicWidgetState extends State<DynamicWidget> {
  UnitLabel? selectedUnit = UnitLabel.select;
  final ingredientController = TextEditingController();
  final amountController = TextEditingController();

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
                controller: amountController,
              ),
            ),
            SizedBox(width: size.width / 64),
            SizedBox(
              width: ((size.width / 32) * 7),
              child: DropdownButtonFormField<UnitLabel>(
                isDense: true,
                value: selectedUnit,
                onChanged: (UnitLabel? value) {
                  setState(() {
                    selectedUnit = value!;
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
                controller: ingredientController,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8.0),
      ],
    );
  }
}
