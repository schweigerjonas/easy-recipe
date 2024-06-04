import 'dart:convert';
import 'package:easy_recipe/models/recipe.dart';
import 'package:easy_recipe/models/detailed_recipe.dart';
import 'package:http/http.dart' as http;

class RecipeApi {

  final String _baseUrl = 'https://api.spoonacular.com';
  //TODO: in .env Datei auslagern
  final String _apiKey = 'faa10ae21f424bafada3be00631ec0fa';

  Future<DetailedRecipe> getRecipeInformation(int recipeId) async {
    final response = await http.get(Uri.parse('$_baseUrl/recipes/$recipeId/information?apiKey=$_apiKey'));
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      DetailedRecipe recipe = DetailedRecipe.fromJson(jsonResponse);
      return recipe;
    } else {
      throw Exception('Failed to load recipe.');
    }
  }

  Future<List<Recipe>> getRandomRecipes(int number) async {
    final response = await http.get(Uri.parse('$_baseUrl/recipes/random?number=$number&apiKey=$_apiKey'));

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      List<Recipe> recipes = (jsonResponse['recipes'] as List)
          .map((data) => Recipe.fromJson(data))
          .toList();
      return recipes;
    } else {
      throw Exception('Failed to get random recipes.');
    }
  }

  Future<List<Recipe>> getRecipeByName(String name) async {
    final response = await http.get(Uri.parse('$_baseUrl/recipes/complexSearch?addRecipeInformation=true&query=$name&apiKey=$_apiKey'));

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      List<Recipe> recipes = (jsonResponse['results'] as List)
          .map((data) => Recipe.fromJson(data))
          .toList();
      return recipes;
    } else {
      throw Exception('Failed to get recipes.');
    }
  }

  Future<List<Recipe>> searchRecipes(String query) async {
    //TODO: Use filter options as search params

    final response = await http.get(Uri.parse('$_baseUrl/recipes/complexSearch?addRecipeInformation=true&$query&apiKey=$_apiKey'));

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      List<Recipe> recipes = (jsonResponse['results'] as List)
          .map((data) => Recipe.fromJson(data))
          .toList();
      return recipes;
    } else {
      throw Exception('Failed to find recipes with specified parameters.');
    }
  }

  String decodeSpecialCharacters(String input) {
    return utf8.decode(input.codeUnits);
  }
}