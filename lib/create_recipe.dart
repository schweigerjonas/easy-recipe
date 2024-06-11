import 'package:easy_recipe/set_recipe_information.dart';
import 'package:easy_recipe/set_recipe_ingredients.dart';
import 'package:flutter/material.dart';

class CreateRecipePage extends StatefulWidget {
  const CreateRecipePage({super.key});

  @override
  State<CreateRecipePage> createState() => _CreateRecipePageState();
}

class _CreateRecipePageState extends State<CreateRecipePage> {
  int currentPageIndex = 0;
  final screens = [
    const SetRecipeInformation(),
    const SetRecipeIngredients(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentPageIndex],
    );
  }
}
