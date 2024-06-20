import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/application_state.dart';
import '../models/my_recipe_page_model.dart';
import '../models/recipe_card_model.dart';

class RecipeCard extends StatelessWidget {
  final String title;
  final int cookingTime;
  final String thumbnailUrl;
  final VoidCallback onTap;
  final VoidCallback markAsFavoriteNotLoggedIn;
  final int id;
  final bool loggedInState;
  final int userId;

  final ValueNotifier<bool> _isIconChanged = ValueNotifier<bool>(false);

  RecipeCard({
    super.key,
    required this.title,
    required this.cookingTime,
    required this.thumbnailUrl,
    required this.onTap,
    required this.markAsFavoriteNotLoggedIn,
    required this.id,
    required this.loggedInState,
    required this.userId
  });

  @override
  Widget build(BuildContext context) {
    if (Provider.of<RecipeCardModel>(context, listen: false).savedRecipes.contains(id)) {
      _isIconChanged.value = true;
    }
    Future openDialog() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Login required'),
        content: const Text('You need to be logged in to do this!'),
        actions: [
          TextButton(
              onPressed: markAsFavoriteNotLoggedIn,
              child: const Text('LOGIN')
          ),
        ],
      ),
    );

    Future openDeleteDialog() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: const Text('Do you really want to delete this recipe from your favorites?'),
        actions: [
          TextButton(
              onPressed: () async {
                _isIconChanged.value = false;
                await Provider.of<ApplicationState>(context, listen: false).deleteRecipeFromFavorites(id);
                if (context.mounted) {
                  var recipes = await Provider.of<ApplicationState>(context, listen: false).getSavedRecipes();
                  if (context.mounted) {
                    Provider.of<MyRecipePageModel>(context, listen: false).setRecipes(recipes);
                  }
                }
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              },
              child: const Text('YES')
          ),
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('NO')
          ),
        ],
      ),
    );

    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
        width: MediaQuery.of(context).size.width,
        height: 180,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.6),
              offset: const Offset(
                0.0,
                10.0,
              ),
              blurRadius: 10.0,
              spreadRadius: -6.0,
            ),
          ],
          image: DecorationImage(
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.35),
              BlendMode.multiply,
            ),
            image: NetworkImage(thumbnailUrl),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 19,
                    color: Colors.white
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ValueListenableBuilder(
                      valueListenable: _isIconChanged,
                      builder: (context, isIconChanged, child) {
                        return IconButton(
                            icon: Icon(
                              isIconChanged ? Icons.favorite : Icons.favorite_border,
                              color: Colors.red,
                              size: 24,
                            ),
                            onPressed: () async {
                              if (loggedInState == true) {
                                if (_isIconChanged.value == false) {
                                  _isIconChanged.value = true;
                                  await Provider.of<ApplicationState>(context, listen: false).saveAsFavorite(id);
                                  if (context.mounted) {
                                    var recipes = await Provider.of<ApplicationState>(context, listen: false).getSavedRecipes();
                                    if (context.mounted) {
                                      Provider.of<MyRecipePageModel>(context, listen: false).setRecipes(recipes);
                                    }
                                  }
                                } else {
                                  openDeleteDialog();
                                }
                              } else {
                                openDialog();
                              }
                            }
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(5),
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.schedule,
                          color: Colors.yellow,
                          size: 18,
                        ),
                        const SizedBox(width: 7),
                        Text("${cookingTime}min", style: const TextStyle(color: Colors.white),),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}