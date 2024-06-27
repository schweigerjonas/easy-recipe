import 'package:easy_recipe/views/recipe_detail_view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../models/application_state.dart';
import '../models/creation_model.dart';
import '../models/detailed_recipe.dart';

class ShowRecipePreview extends StatefulWidget {
  const ShowRecipePreview({super.key});

  @override
  State<ShowRecipePreview> createState() => _ShowRecipePreviewState();
}

class _ShowRecipePreviewState extends State<ShowRecipePreview> {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const Text('Preview',
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          const SizedBox(height: 32.0),
          Consumer<CreationModel>(
            builder: (context, creation, _) => Expanded(
              child: RecipeDetailView(
                  idRecipe: creation.getId(),
                  title: creation.getRecipeTitle(),
                  image: creation.getImageUrl(),
                  cookingTime: creation.getTimeToCook(),
                  id: creation.getId(),
                  servings: creation.getServings(),
                  isVegan: creation.getIsVegan(),
                  isVegetarian: creation.getIsVegetarian(),
                  isDairyFree: creation.getIsDairyFree(),
                  isGlutenFree: creation.getIsGlutenFree(),
                  summary: creation.getSummary(),
                  score: creation.getScore(),
                  ingredients: creation.getIngredients(),
                  instructions: creation.getInstructions(),
              ),
            ),
          ),
          const SizedBox(height: 24.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () {
                  Provider.of<CreationModel>(context, listen: false)
                      .setPageIndex(3);
                },
                child: const Text('Back'),
              ),
              Consumer<CreationModel>(
                builder: (context, creation, _) => ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                  ),
                  onPressed: () {
                    DetailedRecipe recipe = creation.createRecipe();
                    Provider.of<ApplicationState>(context, listen: false,).saveCreatedRecipe(recipe);

                    // TODO: create callback to go back to homepage
                    context.go("/");
                  },
                  child: const Text('Create Recipe'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}