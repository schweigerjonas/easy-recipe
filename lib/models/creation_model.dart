import 'package:easy_recipe/models/detailed_recipe.dart';
import 'package:easy_recipe/views/set_recipe_information.dart';
import 'package:flutter/material.dart';

import 'application_state.dart';

class CreationModel extends ChangeNotifier {
  int currentPageIndex = 0;

  String title = "";
  String image = "";
  int cookingTime = 0;
  int id = 0;
  int servings = 0;
  bool isVegetarian = false;
  bool isVegan = false;
  bool isDairyFree = false;
  bool isGlutenFree = false;
  String summary = "";
  double score = 0.0;
  List<String> ingredients = [];
  String instructions = "";

  final VoidCallback backToHome;

  CreationModel({
    required this.backToHome
  });

  void setPageIndex(int index) {
    currentPageIndex = index;
    notifyListeners();
  }

  void setRecipeTitle(String title) {
    this.title = title;
    notifyListeners();
  }

  String getRecipeTitle() {
    return title;
  }

  void setServings(int servings) {
    this.servings = servings;
    notifyListeners();
  }

  int getServings() {
    return servings;
  }

  void setTimeToCook(int time) {
    cookingTime = time;
    notifyListeners();
  }

  int getTimeToCook() {
    return cookingTime;
  }

  void setCategories(List<Category?> selectedCategories) {
    for (var i=0; i<selectedCategories.length; i++) {
      switch (selectedCategories.elementAt(i)?.id) {
        case 1:
          isVegetarian = selectedCategories.elementAt(i)!.isSet;
          break;
        case 2:
          isVegan = selectedCategories.elementAt(i)!.isSet;
          break;
        case 3:
          isDairyFree = selectedCategories.elementAt(i)!.isSet;
          break;
        case 4:
          isGlutenFree = selectedCategories.elementAt(i)!.isSet;
          break;
      }
    }
    notifyListeners();
  }

  bool getIsVegetarian() {
    return isVegetarian;
  }

  bool getIsVegan() {
    return isVegan;
  }

  bool getIsDairyFree() {
    return isDairyFree;
  }

  bool getIsGlutenFree() {
    return isGlutenFree;
  }

  void setIngredients(List<String> ingredients) {
    this.ingredients = ingredients;
    notifyListeners();
  }

  List<String> getIngredients() {
    return ingredients;
  }

  void setInstructions(String instructions) {
    this.instructions = instructions;
    notifyListeners();
  }

  String getInstructions() {
    return instructions;
  }

  void setSummary(String summary) {
    this.summary = summary;
    notifyListeners();
  }

  String getSummary() {
    return summary;
  }

  void setImageUrl(String url) {
    image = url;
    notifyListeners();
  }

  String getImageUrl() {
    return image;
  }

  void setScore(double score) {
    this.score = score;
    notifyListeners();
  }

  double getScore() {
    return score;
  }

  // creates random id for the recipe in 1500000 <= x < maxIntegerValue
  void setId() async {
    id = await ApplicationState().getLastSavedId();
    ApplicationState().increaseSavedId();
    notifyListeners();
  }

  int getId() {
    return id;
  }

  DetailedRecipe createRecipe() {

    return DetailedRecipe(
        title: title,
        image: image,
        cookingTime: cookingTime,
        id: id,
        servings: servings,
        isVegan: isVegan,
        isVegetarian: isVegetarian,
        isDairyFree: isDairyFree,
        isGlutenFree: isGlutenFree,
        summary: summary,
        score: score,
        ingredients: ingredients,
        instructions: instructions);
  }
}