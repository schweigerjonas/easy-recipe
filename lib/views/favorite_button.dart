import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/application_state.dart';
import '../models/my_recipe_page_model.dart';

class FavoriteButton extends StatelessWidget {
  final int id;
  final VoidCallback markAsFavoriteNotLoggedIn;

  final ValueNotifier<bool> _isIconChanged = ValueNotifier<bool>(false);

  FavoriteButton({
    super.key,
    required this.id,
    required this.markAsFavoriteNotLoggedIn
  });

  @override
  Widget build(BuildContext context) {

    if (Provider.of<MyRecipePageModel>(context, listen: false).getRecipeIDs.contains(id)) {
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
                    var recipeIDs = await Provider.of<ApplicationState>(context, listen: false).getRecipeIDs();
                    if (context.mounted) {
                      Provider.of<MyRecipePageModel>(context, listen: false).setRecipes(recipes);
                      Provider.of<MyRecipePageModel>(context, listen: false).setRecipeIDs(recipeIDs);
                    }
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

    return ValueListenableBuilder(
      valueListenable: _isIconChanged,
      builder: (context, isIconChanged, child) {
        return IconButton(
            icon: Icon(
              isIconChanged ? Icons.favorite : Icons.favorite_border,
              color: Colors.red,
              size: 24,
            ),
            onPressed: () async {
              if (Provider.of<ApplicationState>(context, listen: false).loggedIn == true) {
                if (_isIconChanged.value == false) {
                  _isIconChanged.value = true;
                  await Provider.of<ApplicationState>(context, listen: false).saveAsFavorite(id);
                  if (context.mounted) {
                    var recipes = await Provider.of<ApplicationState>(context, listen: false).getSavedRecipes();
                    if (context.mounted) {
                      var recipeIDs = await Provider.of<ApplicationState>(context, listen: false).getRecipeIDs();
                      if (context.mounted) {
                        Provider.of<MyRecipePageModel>(context, listen: false).setRecipes(recipes);
                        Provider.of<MyRecipePageModel>(context, listen: false).setRecipeIDs(recipeIDs);
                      }
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
    );
  }

}