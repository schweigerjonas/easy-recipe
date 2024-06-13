import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'creation_model.dart';
import 'dynamic_widget.dart';

enum UnitLabel {
  select(label: '-select-'),
  milliliter(label: 'ml'),
  liter(label: 'l'),
  gram(label: 'g'),
  kilogram(label: 'kg'),
  teaspoon(label: 'tsp'),
  tablespoon(label: 'tbsp');

  const UnitLabel({required this.label});

  final String label;
}

class SetRecipeIngredients extends StatefulWidget {
  const SetRecipeIngredients({super.key});

  @override
  State<SetRecipeIngredients> createState() => _SetRecipeIngredientsState();
}

class _SetRecipeIngredientsState extends State<SetRecipeIngredients> {
  UnitLabel? selectedUnit = UnitLabel.select;
  List<DynamicWidget> container = [
    const DynamicWidget(),
    const DynamicWidget(),
    const DynamicWidget(),
  ];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: ((size.width / 64) * 2)),
      child: ListView(
        shrinkWrap: true,
        children: [
          const Text(
            'Ingredients',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          const SizedBox(height: 32.0),
          Row(
            children: [
              SizedBox(
                width: ((size.width / 32) * 5),
                child: const Text(
                  'Amount',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
              ),
              SizedBox(width: size.width / 64),
              SizedBox(
                width: ((size.width / 32) * 7),
                child: const Text(
                  'Unit',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
              ),
              SizedBox(width: size.width / 64),
              SizedBox(
                width: ((size.width / 8) * 4),
                child: const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Ingredient',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          Column(
            children: container,
          ),
          const SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState( () {
                    container.insert(0, const DynamicWidget());
                  });
                },
                child: const Text('Add Ingredient'),
              ),
              const SizedBox(width: 8.0),
              ElevatedButton(
                onPressed: () {
                  if(container.isNotEmpty) {
                    setState( () {
                      container.removeAt(0);
                    });
                  }
                },
                child: const Icon(Icons.delete),
              )
            ],
          ),
          const SizedBox(height: 24.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  Provider.of<CreationModel>(context, listen: false)
                      .setPageIndex(0);
                },
                child: const Text('Back'),
              ),
              ElevatedButton(
                onPressed: () {
                  Provider.of<CreationModel>(context, listen: false)
                      .setPageIndex(2);
                },
                child: const Text('Next Step'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
