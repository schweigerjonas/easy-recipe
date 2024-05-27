import 'dart:convert';
import 'package:easy_recipe/models/recipe.dart';
import 'package:http/http.dart' as http;

class RecipeApi {
  static Future<List<Recipe>> getRecipe() async {

    var uri = Uri.https('gustar-io-deutsche-rezepte.p.rapidapi.com', '/search_api',
        {"text": 'Schnitzel'});

    final response = await http.get(uri, headers: {
      'x-rapidapi-key': 'aa133d4de9msh2426222591727d4p1de843jsn4fb499757562',
      'x-rapidapi-host': 'gustar-io-deutsche-rezepte.p.rapidapi.com',
      "useQueryString": "true"
    });

    List data = jsonDecode(response.body);

    return Recipe.recipesFromSnapshot(data);
  }
}