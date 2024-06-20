import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_recipe/models/detailed_recipe.dart';
import 'package:easy_recipe/models/recipe.dart';
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

  Future<DetailedRecipe> getSavedRecipeDetails(int id) async {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('recipes')
        .where('id', isEqualTo: id)
        .where('userId', isEqualTo: FirebaseAuth.instance.currentUser?.uid).get();

    var data = snapshot.docs[0].data() as Map<String, dynamic>;
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
        ingredients: data['ingredients'] as List<String>,
        instructions: data['instructions'] as String
    );

    return recipe;
  }
  
  Future<List<Recipe>> getSavedRecipesByFilter(int maxTime, List<String> diets) async {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

    /*bool vegetarian = false;
    bool vegan = false;
    bool glutenFree = false;
    bool dairyFree = false;
    
    if (diets.isNotEmpty) {
      if (diets.contains('vegetarian')) {
        vegetarian = true;
      }
      if (diets.contains('vegan')) {
        vegan = true;
      }
      if (diets.contains('gluten-free')) {
        glutenFree = true;
      }
      if (diets.contains('dairy-free')) {
        dairyFree = true;
      }
    } 
    late QuerySnapshot snapshot;
    
    if (vegetarian) {
      if (vegan) {
        if (glutenFree) {
          if (dairyFree) {
            //v, vv, g, d
            if (maxTime != 0) {
              snapshot = await FirebaseFirestore.instance
                  .collection('recipes')
                  .where('isVegetarian', isEqualTo: true)
                  .where('isVegan', isEqualTo: true)
                  .where('isGlutenFree', isEqualTo: true)
                  .where('isDairyFree', isEqualTo: true)
                  .where('cookingTime', isLessThanOrEqualTo: maxTime)
                  .where('userId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                  .orderBy('title', descending: false).get();
            } else {
              snapshot = await FirebaseFirestore.instance
                  .collection('recipes')
                  .where('isVegetarian', isEqualTo: true)
                  .where('isVegan', isEqualTo: true)
                  .where('isGlutenFree', isEqualTo: true)
                  .where('isDairyFree', isEqualTo: true)
                  .where('userId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                  .orderBy('title', descending: false).get();
            }
          } else {
            //v, vv, g
            if (maxTime != 0) {
              snapshot = await FirebaseFirestore.instance
                  .collection('recipes')
                  .where('isVegetarian', isEqualTo: true)
                  .where('isVegan', isEqualTo: true)
                  .where('isGlutenFree', isEqualTo: true)
                  .where('cookingTime', isLessThanOrEqualTo: maxTime)
                  .where('userId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                  .orderBy('title', descending: false).get();
            } else {
              snapshot = await FirebaseFirestore.instance
                  .collection('recipes')
                  .where('isVegetarian', isEqualTo: true)
                  .where('isVegan', isEqualTo: true)
                  .where('isGlutenFree', isEqualTo: true)
                  .where('userId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                  .orderBy('title', descending: false).get();
            }
          }
        } else {
          if (dairyFree) {
            //v, vv, d
            if (maxTime != 0) {
              snapshot = await FirebaseFirestore.instance
                  .collection('recipes')
                  .where('isVegetarian', isEqualTo: true)
                  .where('isVegan', isEqualTo: true)
                  .where('isDairyFree', isEqualTo: true)
                  .where('cookingTime', isLessThanOrEqualTo: maxTime)
                  .where('userId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                  .orderBy('title', descending: false).get();
            } else {
              snapshot = await FirebaseFirestore.instance
                  .collection('recipes')
                  .where('isVegetarian', isEqualTo: true)
                  .where('isVegan', isEqualTo: true)
                  .where('isDairyFree', isEqualTo: true)
                  .where('userId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                  .orderBy('title', descending: false).get();
            }
          } else {
            //v, vv
            if (maxTime != 0) {
              snapshot = await FirebaseFirestore.instance
                  .collection('recipes')
                  .where('isVegetarian', isEqualTo: true)
                  .where('isVegan', isEqualTo: true)
                  .where('cookingTime', isLessThanOrEqualTo: maxTime)
                  .where('userId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                  .orderBy('title', descending: false).get();
            } else {
              snapshot = await FirebaseFirestore.instance
                  .collection('recipes')
                  .where('isVegetarian', isEqualTo: true)
                  .where('isVegan', isEqualTo: true)
                  .where('userId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                  .orderBy('title', descending: false).get();
            }
          }
        }
      } else {
        if (glutenFree) {
          if (dairyFree) {
            //v, g, d
            if (maxTime != 0) {
              snapshot = await FirebaseFirestore.instance
                  .collection('recipes')
                  .where('isVegetarian', isEqualTo: true)
                  .where('isGlutenFree', isEqualTo: true)
                  .where('isDairyFree', isEqualTo: true)
                  .where('cookingTime', isLessThanOrEqualTo: maxTime)
                  .where('userId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                  .orderBy('title', descending: false).get();
            } else {
              snapshot = await FirebaseFirestore.instance
                  .collection('recipes')
                  .where('isVegetarian', isEqualTo: true)
                  .where('isGlutenFree', isEqualTo: true)
                  .where('isDairyFree', isEqualTo: true)
                  .where('userId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                  .orderBy('title', descending: false).get();
            }
          } else {
            //v, g
            if (maxTime != 0) {
              snapshot = await FirebaseFirestore.instance
                  .collection('recipes')
                  .where('isVegetarian', isEqualTo: true)
                  .where('isGlutenFree', isEqualTo: true)
                  .where('cookingTime', isLessThanOrEqualTo: maxTime)
                  .where('userId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                  .orderBy('title', descending: false).get();
            } else {
              snapshot = await FirebaseFirestore.instance
                  .collection('recipes')
                  .where('isVegetarian', isEqualTo: true)
                  .where('isGlutenFree', isEqualTo: true)
                  .where('userId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                  .orderBy('title', descending: false).get();
            }
          }
        } else {
          if (dairyFree) {
            //v, d
            if (maxTime != 0) {
              snapshot = await FirebaseFirestore.instance
                  .collection('recipes')
                  .where('isVegetarian', isEqualTo: true)
                  .where('isDairyFree', isEqualTo: true)
                  .where('cookingTime', isLessThanOrEqualTo: maxTime)
                  .where('userId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                  .orderBy('title', descending: false).get();
            } else {
              snapshot = await FirebaseFirestore.instance
                  .collection('recipes')
                  .where('isVegetarian', isEqualTo: true)
                  .where('isDairyFree', isEqualTo: true)
                  .where('userId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                  .orderBy('title', descending: false).get();
            }
          } else {
            //v
            if (maxTime != 0) {
              snapshot = await FirebaseFirestore.instance
                  .collection('recipes')
                  .where('isVegetarian', isEqualTo: true)
                  .where('cookingTime', isLessThanOrEqualTo: maxTime)
                  .where('userId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                  .orderBy('title', descending: false).get();
            } else {
              snapshot = await FirebaseFirestore.instance
                  .collection('recipes')
                  .where('isVegetarian', isEqualTo: true)
                  .where('userId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                  .orderBy('title', descending: false).get();
            }
          }
        }
      }
    } else {
      if (vegan) {
        if (glutenFree) {
          if (dairyFree) {
            //vv, g, d
            if (maxTime != 0) {
              snapshot = await FirebaseFirestore.instance
                  .collection('recipes')
                  .where('isVegan', isEqualTo: true)
                  .where('isGlutenFree', isEqualTo: true)
                  .where('isDairyFree', isEqualTo: true)
                  .where('cookingTime', isLessThanOrEqualTo: maxTime)
                  .where('userId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                  .orderBy('title', descending: false).get();
            } else {
              snapshot = await FirebaseFirestore.instance
                  .collection('recipes')
                  .where('isVegan', isEqualTo: true)
                  .where('isGlutenFree', isEqualTo: true)
                  .where('isDairyFree', isEqualTo: true)
                  .where('userId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                  .orderBy('title', descending: false).get();
            }
          } else {
            //vv, g
            if (maxTime != 0) {
              snapshot = await FirebaseFirestore.instance
                  .collection('recipes')
                  .where('isVegan', isEqualTo: true)
                  .where('isGlutenFree', isEqualTo: true)
                  .where('cookingTime', isLessThanOrEqualTo: maxTime)
                  .where('userId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                  .orderBy('title', descending: false).get();
            } else {
              snapshot = await FirebaseFirestore.instance
                  .collection('recipes')
                  .where('isVegan', isEqualTo: true)
                  .where('isGlutenFree', isEqualTo: true)
                  .where('userId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                  .orderBy('title', descending: false).get();
            }
          }
        } else {
          if (dairyFree) {
            //vv, d
            if (maxTime != 0) {
              snapshot = await FirebaseFirestore.instance
                  .collection('recipes')
                  .where('isVegan', isEqualTo: true)
                  .where('isDairyFree', isEqualTo: true)
                  .where('cookingTime', isLessThanOrEqualTo: maxTime)
                  .where('userId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                  .orderBy('title', descending: false).get();
            } else {
              snapshot = await FirebaseFirestore.instance
                  .collection('recipes')
                  .where('isVegan', isEqualTo: true)
                  .where('isDairyFree', isEqualTo: true)
                  .where('userId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                  .orderBy('title', descending: false).get();
            }
          } else {
            //vv
            if (maxTime != 0) {
              snapshot = await FirebaseFirestore.instance
                  .collection('recipes')
                  .where('isVegan', isEqualTo: true)
                  .where('cookingTime', isLessThanOrEqualTo: maxTime)
                  .where('userId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                  .orderBy('title', descending: false).get();
            } else {
              snapshot = await FirebaseFirestore.instance
                  .collection('recipes')
                  .where('isVegan', isEqualTo: true)
                  .where('userId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                  .orderBy('title', descending: false).get();
            }
          }
        }
      } else {
        if (glutenFree) {
          if (dairyFree) {
            //g, d
            if (maxTime != 0) {
              snapshot = await FirebaseFirestore.instance
                  .collection('recipes')
                  .where('isGlutenFree', isEqualTo: true)
                  .where('isDairyFree', isEqualTo: true)
                  .where('cookingTime', isLessThanOrEqualTo: maxTime)
                  .where('userId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                  .orderBy('title', descending: false).get();
            } else {
              snapshot = await FirebaseFirestore.instance
                  .collection('recipes')
                  .where('isGlutenFree', isEqualTo: true)
                  .where('isDairyFree', isEqualTo: true)
                  .where('userId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                  .orderBy('title', descending: false).get();
            }
          } else {
            //g
            if (maxTime != 0) {
              snapshot = await FirebaseFirestore.instance
                  .collection('recipes')
                  .where('isGlutenFree', isEqualTo: true)
                  .where('cookingTime', isLessThanOrEqualTo: maxTime)
                  .where('userId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                  .orderBy('title', descending: false).get();
            } else {
              snapshot = await FirebaseFirestore.instance
                  .collection('recipes')
                  .where('isGlutenFree', isEqualTo: true)
                  .where('userId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                  .orderBy('title', descending: false).get();
            }
          }
        } else {
          if (dairyFree) {
            //d
            if (maxTime != 0) {
              snapshot = await FirebaseFirestore.instance
                  .collection('recipes')
                  .where('isDairyFree', isEqualTo: true)
                  .where('cookingTime', isLessThanOrEqualTo: maxTime)
                  .where('userId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                  .orderBy('title', descending: false).get();
            } else {
              snapshot = await FirebaseFirestore.instance
                  .collection('recipes')
                  .where('isDairyFree', isEqualTo: true)
                  .where('userId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                  .orderBy('title', descending: false).get();
            }
          } else {
            //nothing
            if (maxTime != 0) {
              snapshot = await FirebaseFirestore.instance
                  .collection('recipes')
                  .where('cookingTime', isLessThanOrEqualTo: maxTime)
                  .where('userId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                  .orderBy('title', descending: false).get();
            } else {
              throw UnimplementedError();
            }
          }
        }
      }
    }*/

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