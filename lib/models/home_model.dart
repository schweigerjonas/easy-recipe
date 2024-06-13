import 'package:easy_recipe/models/recipe.dart';
import 'package:flutter/material.dart';

import 'filter_option.dart';

class HomePageModel extends ChangeNotifier {

  int randomRecipeCount = 5;
  List<Recipe> _recipes = [];

  List<FilterOption> _selectedFilterOptions = [];

  List<Recipe> get getRecipes => _recipes;

  void setRecipes(List<Recipe> newRecipes) {
    _recipes = newRecipes;
    notifyListeners();
  }

  List<FilterOption> get getSelectedFilerOptions => _selectedFilterOptions;

  void setSelectedFilterOptions(List<FilterOption> newOption) {
    _selectedFilterOptions = newOption;
    notifyListeners();
  }
}