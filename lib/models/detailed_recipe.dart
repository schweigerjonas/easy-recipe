import 'package:easy_recipe/models/recipe.api.dart';

class DetailedRecipe {
  final String title;
  final String image;
  final int cookingTime;
  final int id;
  final int servings;
  final bool isVegan;
  final bool isVegetarian;
  final bool isDairyFree;
  final bool isGlutenFree;
  final String summary;
  final double score;
  final List<String> ingredients;
  final String instructions;

  DetailedRecipe({
    required this.title,
    required this.image,
    required this.cookingTime,
    required this.id,
    required this.servings,
    required this.isVegan,
    required this.isVegetarian,
    required this.isDairyFree,
    required this.isGlutenFree,
    required this.summary,
    required this.score,
    required this.ingredients,
    required this.instructions
  });

  factory DetailedRecipe.fromJson(dynamic json) {
    return DetailedRecipe(
        title: json['title'] as String,
        image: (json['image'] ?? 'https://fakeimg.pl/312x231?text=No+Image+Available') as String,
        cookingTime: json['readyInMinutes'] as int,
        id: json['id'] as int,
        servings: json['servings'] as int,
        isVegan: json['vegan'] as bool,
        isVegetarian: json['vegetarian'] as bool,
        isDairyFree: json['dairyFree'] as bool,
        isGlutenFree: json['glutenFree'] as bool,
        summary: json['summary'] as String,
        score: json['spoonacularScore'] as double,
        ingredients: fetchIngredients(json),
        instructions: json['instructions'] as String
    );
  }

  static List<DetailedRecipe> recipesFromSnapshot(List snapshot) {
    return snapshot.map((data) {
      return DetailedRecipe.fromJson(data);
    }).toList();
  }

  static List<String> fetchIngredients(dynamic json) {
    List<String> ingredients = [];
    for (var i=0; i<json['extendedIngredients'].length; i++) {
      ingredients.add(RecipeApi().decodeSpecialCharacters(json['extendedIngredients'][i]['original']));
    }
    return ingredients;
  }

  @override
  String toString(){
    return 'Recipe {name: $title, time: $cookingTime, image: $image}';
  }
}