import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'creation_model.dart';
import 'dynamic_widget.dart';

class SetRecipeInformation extends StatefulWidget {
  const SetRecipeInformation({super.key});

  @override
  State<SetRecipeInformation> createState() => _SetRecipeInformationState();
}

class _SetRecipeInformationState extends State<SetRecipeInformation> {
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
                  const Text('Recipe Name'),
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
                  ElevatedButton(
                    onPressed: () {
                      Provider.of<CreationModel>(context, listen: false).setPageIndex(1);
                    },
                    child: const Text('Next Step'),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}