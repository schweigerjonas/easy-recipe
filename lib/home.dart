import 'package:easy_recipe/models/detailed_recipe.dart';
import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:easy_recipe/models/recipe.api.dart';
import 'package:easy_recipe/models/recipe.dart';
import 'package:easy_recipe/recipe_card.dart';

import 'filter_option.dart';
import 'recipe_detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  late List<Recipe> _recipes = [];
  int randomRecipeCount = 5;
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
    FilterOption(id: 7, name: 'ketogenic'),

    FilterOption(id: 8, name: 'breakfast'),
    FilterOption(id: 9, name: 'lunch'),
    FilterOption(id: 10, name: 'dinner'),
    FilterOption(id: 11, name: 'appetizer'),
    FilterOption(id: 12, name: 'main dish'),
    FilterOption(id: 13, name: 'side dish'),
    FilterOption(id: 14, name: 'snack'),
  ];

  final _items = _filterOptions
      .map((filterOption) => MultiSelectItem<FilterOption>(filterOption, filterOption.name))
      .toList();

  List<FilterOption> _selectedFilterOptions = [];

  @override
  void initState() {
    _selectedFilterOptions = [];
    super.initState();
    getRecipes();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    searchController.dispose();
    super.dispose();
  }

  Future<void> getRecipesByName(String name) async {
    setState(() {
      _isLoading = true;
    });
    _recipes = await RecipeApi().getRecipeByName(name);
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> getRecipes() async {
    _recipes = await RecipeApi().getRandomRecipes(randomRecipeCount);
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> searchRecipesByFilter() async {
    int maxTime = 0;
    String timeQuery = '';
    List<String> diets = [];
    String dietQuery = '';
    List<String> types = [];
    String typeQuery = '';
    String query = '';
    for (FilterOption f in _selectedFilterOptions) {
      if (f.id == 0) {
        maxTime = 30;
      }
      if (f.id == 1) {
        maxTime = 45;
      }
      if (f.id == 2) {
        maxTime = 60;
      }

      if (f.id >= 3 && f.id <= 7) {
        diets.add(f.name);
      }

      if (f.id >= 8 && f.id <= 14) {
        types.add(f.name);
      }
    }
    if (maxTime != 0) {
      timeQuery = 'maxReadyTime=${maxTime.toString()}';
    }
    if (diets.isNotEmpty) {
      dietQuery = 'diet=';
      for (var i=0; i<diets.length; i++) {
        if (i != 0) {
          dietQuery += '&';
        }
        dietQuery += diets[i];
      }
    }
    if (types.isNotEmpty) {
      typeQuery = 'type=';
      for (var i=0; i<types.length; i++) {
        if (i != 0) {
          typeQuery += '&';
        }
        typeQuery += types[i];
      }
    }
    if (timeQuery != '') {
      query = timeQuery;
    }
    if (dietQuery != '') {
      if (query == '') {
        query = dietQuery;
      } else {
        query += '&$dietQuery';
      }
    }
    if (typeQuery != '') {
      if (query == '') {
        query = typeQuery;
      } else {
        query += '&$typeQuery';
      }
    }
    setState(() {
      _isLoading = true;
    });
    if (query == '') {
      await getRecipes();
    } else {
      print(query);
      _recipes = await RecipeApi().searchRecipes(query);
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> getInformation(int id) async {
    setState(() {
      _isLoading = true;
    });
    _detailedRecipe = await RecipeApi().getRecipeInformation(id);
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
          initialValue: _selectedFilterOptions,
          onConfirm: (values) {
            setState(() {
              _selectedFilterOptions = values;
              searchRecipesByFilter();
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
                  Expanded(
                    child: TextField(
                      style: const TextStyle(
                        height: 1,
                        color: Color(0xFF8D8D8D),
                      ),
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        hintText: 'Search',
                        hintStyle: TextStyle(
                          color: Color(0xFF8D8D8D),
                        ),
                        filled: true,
                        fillColor: Color(0xFFFFFFFF),
                        border: OutlineInputBorder(),
                      ),
                      controller: searchController,
                      onSubmitted: (String text) {
                        getRecipesByName(searchController.text);
                      },
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
                items: _selectedFilterOptions.map((e) => MultiSelectItem(e, e.name)).toList(),
                scroll: true,
                onTap: (value) {
                  setState(() {
                    _selectedFilterOptions.remove(value);
                    searchRecipesByFilter();
                  });
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 8.0),
              alignment: Alignment.centerLeft,
              child: const Text(
                'Suggested Recipes',
                style: TextStyle(
                  fontSize: 20.0,
                ),
              ),
            ),
            Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                    itemCount: _recipes.length,
                    itemBuilder: (context, index) {
                      final recipe = _recipes[index];

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

          },
        ),
      );
    } else if (currentPageIndex == 2) {
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
        body: RecipeDetailPage(
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
          instructions: _detailedRecipe.instructions
        ),
      );
    } else {
      throw UnimplementedError('no widget for $currentPageIndex');
    }
  }
}
