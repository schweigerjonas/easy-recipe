import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider, PhoneAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';

import 'firebase_options.dart';
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

  Future<List<int>> getRecipeIDs() async {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('recipes').where('userId', isEqualTo: FirebaseAuth.instance.currentUser?.uid).get();
    List<int> recipes = snapshot.docs.map((doc) => doc['id'] as int).toList();
    return recipes;
  }

  Future<void> deleteRecipe(int recipeId) async {
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
}