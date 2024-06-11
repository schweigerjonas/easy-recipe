import 'package:flutter/material.dart';

class SetRecipeIngredients extends StatefulWidget {
  const SetRecipeIngredients({super.key});

  @override
  State<SetRecipeIngredients> createState() => _SetRecipeIngredientsState();
}

class _SetRecipeIngredientsState extends State<SetRecipeIngredients> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Center(
            child: Text('Test'),
        )
    );
  }
}