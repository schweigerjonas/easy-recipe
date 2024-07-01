import 'package:easy_recipe/models/recipe.dart';
import 'package:flutter/material.dart';

import '../utils/filter_option.dart';

class MyRecipePageModel extends ChangeNotifier {

  List<Recipe> _recipes = [];
  List<int> _recipeIDs = [];

  List<FilterOption> _selectedFilterOptions = [];

  List<Recipe> get getRecipes => _recipes;

  List<int> get getRecipeIDs => _recipeIDs;

  void setRecipes(List<Recipe> newRecipes) {
    _recipes = newRecipes;
    notifyListeners();
  }

  void setRecipeIDs(List<int> newRecipes) {
    _recipeIDs = newRecipes;
    notifyListeners();
  }

  List<FilterOption> get getSelectedFilerOptions => _selectedFilterOptions;

  void setSelectedFilterOptions(List<FilterOption> newOption) {
    _selectedFilterOptions = newOption;
    notifyListeners();
  }
}