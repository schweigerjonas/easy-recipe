import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/creation_model.dart';
import 'dynamic_ingredient_widget.dart';

class SetRecipeIngredients extends StatefulWidget {
  const SetRecipeIngredients({super.key});

  @override
  State<SetRecipeIngredients> createState() => _SetRecipeIngredientsState();
}

class _SetRecipeIngredientsState extends State<SetRecipeIngredients> {
  List<String> ingredients = [];
  List<DynamicIngredientWidget> container = [
    DynamicIngredientWidget(controller: IngredientWidgetController()),
    DynamicIngredientWidget(controller: IngredientWidgetController()),
    DynamicIngredientWidget(controller: IngredientWidgetController()),
  ];

  List<String> setIngredients() {
    int i = 0;
    List<String> ingredientList = [];

    //TODO: handle empty lines
    for (DynamicIngredientWidget element in container) {
      String ingredient =
          "${element.controller.getQuantity()} ${element.controller.getUnit()} ${element.controller.getIngredient()}";
      if (ingredient.replaceAll(" ", "").isNotEmpty) {
        ingredientList.insert(i, ingredient);
      }

      i = i + 1;
    }

    return ingredientList;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: 16.0, horizontal: ((size.width / 64) * 2)),
      child: Column(
        children: [
          const Text(
            'Ingredients',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    container.insert(
                        0,
                        DynamicIngredientWidget(
                            controller: IngredientWidgetController()));
                  });
                },
                child: const Text('Add Ingredient'),
              ),
              const SizedBox(width: 8.0),
              ElevatedButton(
                onPressed: () {
                  if (container.isNotEmpty) {
                    setState(() {
                      container.removeAt(0);
                    });
                  }
                },
                child: const Icon(Icons.delete),
              )
            ],
          ),
          Expanded(
            child: ListView(
              shrinkWrap: true,
              children: [
                const SizedBox(height: 16.0),
                Row(
                  children: [
                    SizedBox(
                      width: ((size.width / 32) * 5),
                      child: const Text(
                        'Quantity',
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
                const SizedBox(height: 8.0),
                const SizedBox(height: 24.0),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () {
                  Provider.of<CreationModel>(context, listen: false)
                      .setPageIndex(0);
                },
                child: const Text('Back'),
              ),
              Consumer<CreationModel>(
                builder: (context, creation, _) => ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                  ),
                  onPressed: () {
                    ingredients = setIngredients();
                    creation.setIngredients(ingredients);
                    creation.setPageIndex(2);
                  },
                  child: const Text('Next Step'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
