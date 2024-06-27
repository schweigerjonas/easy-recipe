import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class RecipeDetailView extends StatelessWidget{
  final int idRecipe;
  final String title;
  final String image;
  final int cookingTime;
  final int id;
  final int servings;
  final bool isVegan;
  final bool isVegetarian;
  final bool isGlutenFree;
  final bool isDairyFree;
  final String summary;
  final double score;
  final List<String> ingredients;
  final String instructions;

  const RecipeDetailView({
    super.key,
    required this.idRecipe,
    required this.title,
    required this.image,
    required this.cookingTime,
    required this.id,
    required this.servings,
    required this.isVegan,
    required this.isVegetarian,
    required this.isGlutenFree,
    required this.isDairyFree,
    required this.summary,
    required this.score,
    required this.ingredients,
    required this.instructions
  });

  @override
  Widget build(BuildContext context) {
    String diet = "not vegetarian";
    String gluten = "not gluten-free";
    String dairy = "not dairy-free";

    if (isVegan == true) {
      diet = "vegan";
    } else if (isVegetarian) {
      diet = "vegetarian";
    }
    if (isGlutenFree) {
      gluten = "gluten-free";
    }
    if (isDairyFree) {
      dairy = "dairy-free";
    }
    double scoreRounded = ((score*100).roundToDouble()) / 100;

    String ingredientsList = '';
    for (int i=0; i<ingredients.length; i++) {
      ingredientsList = '$ingredientsList - ${ingredients[i]} \n';
    }

    return ListView(
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
                          servings == 1 ? '$servings person' : '$servings persons',
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
                          MdiIcons.leaf,
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
                          MdiIcons.grain,
                          size: 18,
                        ),
                        const SizedBox(width: 7),
                        Text(
                          gluten,
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
                          MdiIcons.cow,
                          size: 18,
                        ),
                        const SizedBox(width: 7),
                        Text(
                          dairy,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ]
        ),
        Container(
          margin: const EdgeInsets.all(10),
          child: Html(
            data: summary,
          ),
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
          child: const Text('Ingredients',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 10.0),
          child: Text(ingredientsList),
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
          child: const Text('Instructions',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 10.0),
          child: Html(
            data: instructions,
          ),
        ),
      ],
    );
  }

}