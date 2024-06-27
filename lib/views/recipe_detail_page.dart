import 'package:easy_recipe/views/recipe_detail_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'favorite_button.dart';

class RecipeDetailPage extends StatelessWidget {
  final int idRecipe;
  final String title;
  final String image;
  final int cookingTime;
  final int id;
  final int servings;
  final bool isVegan;
  final bool isVegetarian;
  final bool isGlutenFree;
  final bool isDairyFree;
  final String summary;
  final double score;
  final List<String> ingredients;
  final String instructions;
  final VoidCallback backButtonAction;
  final VoidCallback favoriteButtonAction;

  const RecipeDetailPage({
    super.key,
    required this.idRecipe,
    required this.title,
    required this.image,
    required this.cookingTime,
    required this.id,
    required this.servings,
    required this.isVegan,
    required this.isVegetarian,
    required this.isGlutenFree,
    required this.isDairyFree,
    required this.summary,
    required this.score,
    required this.ingredients,
    required this.instructions,
    required this.backButtonAction,
    required this.favoriteButtonAction
  });

  @override
  Widget build(BuildContext context) {

    /*
    String diet = "not vegetarian";
    String gluten = "not gluten-free";
    String dairy = "not dairy-free";

    if (isVegan == true) {
      diet = "vegan";
    } else if (isVegetarian) {
      diet = "vegetarian";
    }
    if (isGlutenFree) {
      gluten = "gluten-free";
    }
    if (isDairyFree) {
      dairy = "dairy-free";
    }
    double scoreRounded = ((score*100).roundToDouble()) / 100;

    String ingredientsList = '';
    for (int i=0; i<ingredients.length; i++) {
      ingredientsList = '$ingredientsList - ${ingredients[i]} \n';
    }
    */

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffe0e0e0),
        leading: IconButton(
          onPressed: () {
            backButtonAction();
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Color(0xFF3D3D3D),
          ),
        ),
        actions: <Widget>[
          FavoriteButton(
            id: id,
            markAsFavoriteNotLoggedIn: () {
              favoriteButtonAction();
            },
          )
        ],
        automaticallyImplyLeading: false,
      ),
      body: RecipeDetailView(
        idRecipe: idRecipe,
        title: title,
        image: image,
        cookingTime: cookingTime,
        id: id,
        servings: servings,
        isVegan: isVegan,
        isVegetarian: isVegetarian,
        isGlutenFree: isGlutenFree,
        isDairyFree: isDairyFree,
        summary: summary,
        score: score,
        ingredients: ingredients,
        instructions: instructions
      ),
    );
  }

}