import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_recipe/models/detailed_recipe.dart';
import 'package:easy_recipe/models/recipe.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider, PhoneAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';

import '../utils/firebase_options.dart';
import 'recipe.api.dart';

class ApplicationState extends ChangeNotifier {
  ApplicationState() {
    init();
  }

  bool _loggedIn = false;
  bool get loggedIn => _loggedIn;

  Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

    FirebaseUIAuth.configureProviders([
      EmailAuthProvider(),
    ]);

    FirebaseAuth.instance.userChanges().listen((user) {
      if (user != null) {
        _loggedIn = true;
      } else {
        _loggedIn = false;
      }
      notifyListeners();
    });
  }

  Future<DocumentReference> saveAsFavorite (int recipeId) async {
    var detailedRecipe = await RecipeApi().getRecipeInformation(recipeId);
    return FirebaseFirestore.instance
        .collection('recipes')
        .add(<String, dynamic>{
      'id': detailedRecipe.id,
      'title': detailedRecipe.title,
      'image': detailedRecipe.image,
      'cookingTime': detailedRecipe.cookingTime,
      'servings': detailedRecipe.servings,
      'isVegan': detailedRecipe.isVegan,
      'isVegetarian': detailedRecipe.isVegetarian,
      'isDairyFree': detailedRecipe.isDairyFree,
      'isGlutenFree': detailedRecipe.isGlutenFree,
      'summary': detailedRecipe.summary,
      'score': detailedRecipe.score,
      'ingredients': detailedRecipe.ingredients,
      'instructions': detailedRecipe.instructions,
      'userId': FirebaseAuth.instance.currentUser!.uid
    });
  }

  Future<DocumentReference> saveCreatedRecipe (DetailedRecipe recipe) async {
    return FirebaseFirestore.instance
        .collection('recipes')
        .add(<String, dynamic>{
      'id': recipe.id,
      'title': recipe.title,
      'image': recipe.image,
      'cookingTime': recipe.cookingTime,
      'servings': recipe.servings,
      'isVegan': recipe.isVegan,
      'isVegetarian': recipe.isVegetarian,
      'isDairyFree': recipe.isDairyFree,
      'isGlutenFree': recipe.isGlutenFree,
      'summary': recipe.summary,
      'score': recipe.score,
      'ingredients': recipe.ingredients,
      'instructions': recipe.instructions,
      'userId': FirebaseAuth.instance.currentUser!.uid
    });
  }

  Future<List<int>> getRecipeIDs() async {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('recipes')
        .where('userId', isEqualTo: FirebaseAuth.instance.currentUser?.uid).get();
    List<int> recipes = snapshot.docs.map((doc) => doc['id'] as int).toList();
    return recipes;
  }

  Future<void> deleteRecipeFromFavorites(int recipeId) async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('recipes')
          .where('id', isEqualTo: recipeId)
          .where('userId', isEqualTo: FirebaseAuth.instance.currentUser?.uid).get();
      for (QueryDocumentSnapshot doc in snapshot.docs) {
        await FirebaseFirestore.instance.collection('recipes').doc(doc.id).delete();
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Recipe>> getSavedRecipes() async {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('recipes')
        .where('userId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .orderBy('title', descending: false).get();

    List<Recipe> recipes = [];
    for (final document in snapshot.docs) {
      var data = document.data() as Map<String, dynamic>;
      recipes.add(
        Recipe(
          title: data['title'] as String,
          image: data['image'] as String,
          cookingTime: data['cookingTime'] as int,
          id: data['id'] as int,
        ),
      );
    }
    return recipes;
  }
  
  Future<int> getLastSavedId() async {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('lastcreationid').get();
    return snapshot.docs[0]['id'];
  }

  Future<void> increaseSavedId() async {
    int currentId = await getLastSavedId();
    FirebaseFirestore.instance
        .collection('lastcreationid').doc('lastid')
        .update({'id': currentId + 1});
  }

  Future<DetailedRecipe> getSavedRecipeDetails(int id) async {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('recipes')
        .where('id', isEqualTo: id)
        .where('userId', isEqualTo: FirebaseAuth.instance.currentUser?.uid).get();

    var data = snapshot.docs[0].data() as Map<String, dynamic>;

    //data['ingredients' is somehow a List<dynamic>, so these lines are necessary
    List<String> ingredientList = [];
    List<dynamic> ingredients = data['ingredients'];
    for (var ingredient in ingredients) {
      ingredientList.add(ingredient);
    }

    DetailedRecipe recipe = DetailedRecipe(
        title: data['title'] as String,
        image: data['image'] as String,
        cookingTime: data['cookingTime'] as int,
        id: data['id'] as int,
        servings: data['servings'] as int,
        isVegan: data['isVegan'] as bool,
        isVegetarian: data['isVegetarian'] as bool,
        isDairyFree: data['isDairyFree'] as bool,
        isGlutenFree: data['isGlutenFree'] as bool,
        summary: data['summary'] as String,
        score: data['score'] as double,
        ingredients: ingredientList,
        instructions: data['instructions'] as String
    );

    return recipe;
  }
  
  Future<List<Recipe>> getSavedRecipesByFilter(int maxTime, List<String> diets) async {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

    // Basisabfrage
    Query query = FirebaseFirestore.instance.collection('recipes').where('userId', isEqualTo: FirebaseAuth.instance.currentUser?.uid);

    // Filter nach Kochzeit
    if (maxTime > 0) {
      query = query.where('cookingTime', isLessThanOrEqualTo: maxTime);
    }

    // Diätfilter hinzufügen
    if (diets.contains('vegetarian')) {
      query = query.where('isVegetarian', isEqualTo: true);
    }
    if (diets.contains('vegan')) {
      query = query.where('isVegan', isEqualTo: true);
    }
    if (diets.contains('gluten-free')) {
      query = query.where('isGlutenFree', isEqualTo: true);
    }
    if (diets.contains('dairy-free')) {
      query = query.where('isDairyFree', isEqualTo: true);
    }

    // Abfrage ausführen und Ergebnisse verarbeiten
    QuerySnapshot snapshot = await query.orderBy('title', descending: false).get();

    List<Recipe> recipes = [];
    for (final document in snapshot.docs) {
      var data = document.data() as Map<String, dynamic>;
      recipes.add(
        Recipe(
          title: data['title'] as String,
          image: data['image'] as String,
          cookingTime: data['cookingTime'] as int,
          id: data['id'] as int,
        ),
      );
    }
    return recipes;
  }
}