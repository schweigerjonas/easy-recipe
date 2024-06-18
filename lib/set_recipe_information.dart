import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'creation_model.dart';
import 'dynamic_ingredient_widget.dart';

class SetRecipeInformation extends StatefulWidget {
  const SetRecipeInformation({super.key});

  @override
  State<SetRecipeInformation> createState() => _SetRecipeInformationState();
}

class _SetRecipeInformationState extends State<SetRecipeInformation> {
  final recipeNameController = TextEditingController();
  final portionController = TextEditingController();
  final timeController = TextEditingController();

  List<DynamicIngredientWidget> dynamicTextFields = [];
  List<String> ingredientsData = [];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          const Text(
            'Create Recipe',
            textAlign: TextAlign.end,
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          const SizedBox(height: 32.0),
          Expanded(
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                const Text(
                  'Recipe Name',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
                TextField(
                  decoration: const InputDecoration(
                    hintText: 'e.g. Pork Carnitas Tacos',
                  ),
                  controller: recipeNameController,
                ),
                const SizedBox(height: 24.0),
                const Text(
                  'Portions',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
                Row(
                  children: <Widget>[
                    const Text('The recipe is designed for '),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: TextField(
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            hintText: 'e.g. 4',
                          ),
                          controller: portionController,
                        ),
                      ),
                    ),
                    const Text(' persons/portions.'),
                  ],
                ),
                const SizedBox(height: 24.0),
                const Text(
                  'Cooking Time',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
                Row(
                  children: [
                    const Text('It takes '),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: TextField(
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            hintText: 'e.g. 25',
                          ),
                          controller: timeController,
                        ),
                      ),
                    ),
                    const Text('min. to cook the whole recipe.'),
                  ],
                ),
                const SizedBox(height: 24.0),
                ElevatedButton(
                  onPressed: () {
                    Provider.of<CreationModel>(context, listen: false)
                        .setPageIndex(1);
                  },
                  child: const Text('Next Step'),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
