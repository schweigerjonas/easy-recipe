import 'package:flutter/material.dart';

class CreationModel extends ChangeNotifier {
  int currentPageIndex = 0;



  void setPageIndex(int index) {
    currentPageIndex = index;
    notifyListeners();
  }

}

class CreatedRecipe {
  final int id;

  final String title;
  final String image;
  final int cookingTime;
  final int servings;

  final bool isVegetarian;
  final bool isVegan;
  final bool isDairyFree;
  final bool isGlutenFree;
  final bool isKetogenic;

  final String summary;
  final List<String> ingredients;
  final String instructions;

  final double score;

  CreatedRecipe({
    required this.id,
    required this.title,
    required this.image,
    required this.cookingTime,
    required this.servings,
    required this.isVegetarian,
    required this.isVegan,
    required this.isDairyFree,
    required this.isGlutenFree,
    required this.isKetogenic,
    required this.summary,
    required this.ingredients,
    required this.instructions,
    required this.score,
  });
}