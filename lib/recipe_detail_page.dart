import 'package:flutter/material.dart';

class RecipeDetailPage extends StatelessWidget {
  final int idRecipe;
  final String title;
  final String image;
  final int cookingTime;
  final int id;
  final int servings;
  final bool isVegan;
  final bool isVegetarian;
  final String summary;
  final double score;

  const RecipeDetailPage({
    super.key,
    required this.idRecipe,
    required this.title,
    required this.image,
    required this.cookingTime,
    required this.id,
    required this.servings,
    required this.isVegan,
    required this.isVegetarian,
    required this.summary,
    required this.score
  });

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Expanded(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 4.0),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Row(
                children: [
                  Container(
                    color: const Color(0xffff0000),
                    margin: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
                    width: MediaQuery.of(context).size.width/3,
                    height: 180,
                  ),
                  Container(
                    color: const Color(0xffff0000),
                    margin: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
                    width: MediaQuery.of(context).size.width/3,
                    height: 180,
                  )
                ]
            ),
            Expanded(
              child: Text(summary),
            )
          ],
        ),
      ),
    );
  }

}