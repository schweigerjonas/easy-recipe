import 'package:easy_recipe/models/application_state.dart';
import 'package:easy_recipe/models/detailed_recipe.dart';
import 'package:easy_recipe/models/my_recipe_page_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:easy_recipe/models/recipe.api.dart';
import 'package:easy_recipe/views/recipe_card.dart';
import 'package:provider/provider.dart';

import 'create_recipe.dart';
import '../models/creation_model.dart';
import '../models/filter_option.dart';
import 'recipe_detail_page.dart';

class MyRecipePage extends StatefulWidget {
  const MyRecipePage({super.key});

  @override
  State<MyRecipePage> createState() => _MyRecipePageState();
}

class _MyRecipePageState extends State<MyRecipePage> {

  bool _isLoading = true;
  final searchController = TextEditingController();
  int currentPageIndex = 1;
  late int idRecipeClicked;
  late DetailedRecipe _detailedRecipe;
  NavigationDestinationLabelBehavior labelBehavior =
      NavigationDestinationLabelBehavior.onlyShowSelected;

  static final List<FilterOption> _filterOptions = [
    FilterOption(id: 0, name: '30min'),
    FilterOption(id: 1, name: '45min'),
    FilterOption(id: 2, name: '60min'),

    FilterOption(id: 3, name: 'vegetarian'),
    FilterOption(id: 4, name: 'vegan'),
    FilterOption(id: 5, name: 'dairy-free'),
    FilterOption(id: 6, name: 'gluten-free'),
  ];

  final _items = _filterOptions
      .map((filterOption) => MultiSelectItem<FilterOption>(filterOption, filterOption.name))
      .toList();

  @override
  void initState() {
    super.initState();
    if (Provider.of<MyRecipePageModel>(context, listen: false).getRecipes.isEmpty) {
      getSavedRecipes();
    } else {
      setState(() {
        _isLoading = false;
      });
    }
    initSavedRecipes();
  }

  Future<void> getSavedRecipes() async {
    setState(() {
      _isLoading = true;
    });
    final recipes = await Provider.of<ApplicationState>(context, listen: false).getSavedRecipes();
    if (mounted) {
      setState(() {
        Provider.of<MyRecipePageModel>(context, listen: false).setRecipes(recipes);
      });
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> initSavedRecipes() async {
    List<int> savedRecipes = await Provider.of<ApplicationState>(context, listen: false).getRecipeIDs();
    if (mounted) {
      setState(() {
        Provider.of<MyRecipePageModel>(context, listen: false).setRecipeIDs(savedRecipes);
      });
    }
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    searchController.dispose();
    super.dispose();
  }

  Future<void> searchSavedRecipesByFilter() async {
    int maxTime = 0;
    List<String> diets = [];

    var selectedFilterOptions = Provider.of<MyRecipePageModel>(context, listen: false).getSelectedFilerOptions;
    for (FilterOption f in selectedFilterOptions) {
      if (f.id == 0) {
        maxTime = 30;
      }
      if (f.id == 1) {
        maxTime = 45;
      }
      if (f.id == 2) {
        maxTime = 60;
      }

      if (f.id >= 3 && f.id <= 6) {
        diets.add(f.name);
      }
    }

    setState(() {
      _isLoading = true;
    });
    if (maxTime == 0 && diets.isEmpty) {
      await getSavedRecipes();
    } else {
      final recipes = await Provider.of<ApplicationState>(context, listen: false).getSavedRecipesByFilter(maxTime, diets);
      if (mounted) {
        setState(() {
          Provider.of<MyRecipePageModel>(context, listen: false).setRecipes(recipes);
        });
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> getInformation(int id) async {
    setState(() {
      _isLoading = true;
    });
    _detailedRecipe = await Provider.of<ApplicationState>(context, listen: false).getSavedRecipeDetails(id);
    setState(() {
      _isLoading = false;
    });
  }

  void _showMultiSelect(BuildContext context) async {
    await showModalBottomSheet(
      isScrollControlled: true, // required for min/max child size
      context: context,
      builder: (ctx) {
        return  MultiSelectBottomSheet(
          title: const Padding(
            padding: EdgeInsets.fromLTRB(14.0, 8.0, 0.0, 0.0),
            child: Text('Filter'),
          ),
          listType: MultiSelectListType.CHIP,
          items: _items,
          initialValue: Provider.of<MyRecipePageModel>(context, listen: false).getSelectedFilerOptions,
          onConfirm: (values) {
            setState(() {
              //_selectedFilterOptions = values;
              Provider.of<MyRecipePageModel>(context, listen: false).setSelectedFilterOptions(values);
              searchSavedRecipesByFilter();
            });
          },
          /*//to many API calls
          onSelectionChanged: (values) {
            setState(() {
              _selectedFilterOptions = values;
              searchRecipesByFilter();
            });
          },*/
          maxChildSize: 0.8,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (currentPageIndex == 1) {
      return Scaffold(
        body: Column(
          children: [
            Container(
              color: Theme.of(context).colorScheme.primary,
              padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 12.0),
              child: Row(
                children: <Widget>[
                  const Expanded(
                    child: Text(
                      'Your Recipes',
                      style: TextStyle(
                        fontSize: 20,
                        height: 1,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                    ),
                    onPressed: () {
                      _showMultiSelect(context);
                    },
                    child:
                    const Icon(
                      Icons.filter_list,
                      color: Color(0xFF3D3D3D),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 8.0),
              child: MultiSelectChipDisplay(
                items: Provider.of<MyRecipePageModel>(context, listen: false).getSelectedFilerOptions.map((e) => MultiSelectItem(e, e.name)).toList(),
                scroll: true,
                onTap: (value) {
                  setState(() {
                    var selectedFilterOptions = Provider.of<MyRecipePageModel>(context, listen: false).getSelectedFilerOptions;
                    selectedFilterOptions.remove(value);
                    Provider.of<MyRecipePageModel>(context, listen: false).setSelectedFilterOptions(selectedFilterOptions);
                    searchSavedRecipesByFilter();
                  });
                },
              ),
            ),
            Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                    itemCount: Provider.of<MyRecipePageModel>(context).getRecipes.length,
                    itemBuilder: (context, index) {
                      final recipe = Provider.of<MyRecipePageModel>(context).getRecipes[index];

                      // ensures special characters in the title are displayed properly
                      String decodedTitle = RecipeApi().decodeSpecialCharacters(recipe.title);
                      return RecipeCard(
                        title: decodedTitle,
                        cookingTime: recipe.cookingTime,
                        thumbnailUrl: recipe.image,
                        id: recipe.id,
                        onTap: () async {
                          idRecipeClicked = recipe.id;
                          await getInformation(idRecipeClicked);
                          setState(() {
                            currentPageIndex = 2;
                          });
                        },
                        markAsFavoriteNotLoggedIn: () {
                          setState(() {
                            Navigator.of(context).pop();
                            context.go("/sign-in");
                          });
                        },
                      );
                    }
                )
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          child: const Icon(
            Icons.add,
            color: Color(0xFF3D3D3D),
          ),
          onPressed: () {
            setState(() {
              currentPageIndex = 3;
            });
          },
        ),
      );
    } else if (currentPageIndex == 2) {
      return RecipeDetailPage(
        idRecipe: idRecipeClicked,
        title: RecipeApi().decodeSpecialCharacters(_detailedRecipe.title),
        cookingTime: _detailedRecipe.cookingTime,
        id: _detailedRecipe.id,
        image: _detailedRecipe.image,
        isVegan: _detailedRecipe.isVegan,
        isVegetarian: _detailedRecipe.isVegetarian,
        servings: _detailedRecipe.servings,
        summary: RecipeApi().decodeSpecialCharacters(_detailedRecipe.summary),
        score: _detailedRecipe.score,
        ingredients: _detailedRecipe.ingredients,
        instructions: _detailedRecipe.instructions,
        isGlutenFree: _detailedRecipe.isGlutenFree,
        isDairyFree: _detailedRecipe.isDairyFree,
        backButtonAction: () {
          setState(() {
            currentPageIndex = 1;
          });
        },
        favoriteButtonAction: () {
          setState(() {
            Navigator.of(context).pop();
            context.go("/sign-in");
          });
        },
      );
    } else if (currentPageIndex == 3) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xffe0e0e0),
          title: IconButton(
            onPressed: () {
              setState(() {
                currentPageIndex = 1;
              });
            },
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Color(0xFF3D3D3D),
            ),
          ),
          automaticallyImplyLeading: false,
        ),
        body: ChangeNotifierProvider(
          create: (context) => CreationModel(),
          child: const CreateRecipePage(),
        ),
      );
    } else {
      throw UnimplementedError('no widget for $currentPageIndex');
    }
  }
}
