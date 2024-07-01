import 'package:easy_recipe/models/recipe.dart';
import 'package:flutter/material.dart';

import '../utils/filter_option.dart';

class HomePageModel extends ChangeNotifier {

  List<Recipe> _recipes = [];

  List<FilterOption> _selectedFilterOptions = [];

  bool _showMoreRecipesNeeded = false;

  int _offset = 0;

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

  bool get showMoreRecipesNeeded => _showMoreRecipesNeeded;

  void setShowMoreRecipesNeeded(bool value) {
    _showMoreRecipesNeeded = value;
    notifyListeners();
  }

  int get offset => _offset;
  void setOffset(int value) {
    if (value < 0) {
      _offset = 0;
    } else {
      _offset = value;
    }
  }
}