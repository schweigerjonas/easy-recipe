import 'package:flutter/material.dart';

class RecipeCardModel extends ChangeNotifier {
  List<int> _savedRecipes = [];

  List<int> get savedRecipes => _savedRecipes;

  void setSavedRecipes(List<int> newOption) {
    _savedRecipes = newOption;
    notifyListeners();
  }
}