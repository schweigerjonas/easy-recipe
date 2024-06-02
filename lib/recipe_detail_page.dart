import 'package:flutter/cupertino.dart';
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

    String diet = "not vegetarian";
    if (isVegan == true) {
      diet = "vegan";
    } else if (isVegetarian) {
      diet = "vegetarian";
    }
    double scoreRounded = ((score*100).roundToDouble()) / 100;

    return Scaffold(
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
            alignment: Alignment.center,
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Row(
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(12.0, 8.0, 10.0, 8.0),
                  width: MediaQuery.of(context).size.width/2,
                  height: MediaQuery.of(context).size.width/2,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    image: DecorationImage(
                      image: NetworkImage(image),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(5),
                      margin: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: const Color(0xFF3D3D3D),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.star_border,
                            color: Colors.white,
                            size: 18,
                          ),
                          const SizedBox(width: 7),
                          Text(
                            scoreRounded.toString(),
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(5),
                      margin: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: const Color(0xffe0e0e0),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.schedule,
                            size: 18,
                          ),
                          const SizedBox(width: 7),
                          Text(
                              '$cookingTime min',
                              style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(5),
                      margin: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: const Color(0xffe0e0e0),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.flatware,
                            size: 18,
                          ),
                          const SizedBox(width: 7),
                          Text(
                            '$servings persons',
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(5),
                      margin: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: const Color(0xffe0e0e0),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.food_bank_outlined,
                            size: 18,
                          ),
                          const SizedBox(width: 7),
                          Text(
                            diet,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ]
          ),
          Expanded(
            child: Text(summary),
          )
        ],
      ),
    );
  }

}