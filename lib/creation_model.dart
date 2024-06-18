import 'package:flutter/material.dart';

class CreationModel extends ChangeNotifier {
  int currentPageIndex = 0;

  String title = "";
  String image = "";
  int cookingTime = 0;
  int id = 0;
  int servings = 0;
  bool isVegan = false;
  bool isVegetarian = false;
  bool isDairyFree = false;
  bool isGlutenFree = false;
  String summary = "";
  double score = 0.0;
  List<String> ingredients = [];
  String instructions = "";


  void setPageIndex(int index) {
    currentPageIndex = index;
    notifyListeners();
  }

  void setIngredients(List<String> ingredients) {
    this.ingredients = ingredients;
    notifyListeners();
  }

  List<String> getIngredients() {
    return ingredients;
  }
}