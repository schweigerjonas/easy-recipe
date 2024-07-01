import 'package:easy_recipe/widgets/recipe_detail_widget.dart';
import 'package:flutter/material.dart';

import '../widgets/favorite_button.dart';

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