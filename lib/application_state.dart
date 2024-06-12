import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider, PhoneAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';

import 'firebase_options.dart';
import 'models/recipe.api.dart';

class ApplicationState extends ChangeNotifier {
  ApplicationState() {
    init();
  }

  bool _loggedIn = false;
  bool get loggedIn => _loggedIn;

  Future<void> init() async {
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
}