import 'package:easy_recipe/views/recipe-creation-views/set_recipe_information.dart';
import 'package:easy_recipe/views/recipe-creation-views/set_recipe_ingredients.dart';

import 'package:easy_recipe/views/recipe-creation-views/set_recipe_instructions.dart';
import 'package:easy_recipe/views/recipe-creation-views/set_recipe_summary.dart';
import 'package:easy_recipe/views/recipe-creation-views/show_recipe_preview.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/creation_model.dart';

class CreateRecipePage extends StatefulWidget {
  const CreateRecipePage({super.key});

  @override
  State<CreateRecipePage> createState() => _CreateRecipePageState();
}

class _CreateRecipePageState extends State<CreateRecipePage> {
  final screens = [
    const SetRecipeInformation(),
    const SetRecipeIngredients(),
    const SetRecipeInstructions(),
    const SetRecipeSummary(),
    const ShowRecipePreview(),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<CreationModel>(
      builder: (context, creation, child) {
        return screens[creation.currentPageIndex];
      }
    );
  }
}
