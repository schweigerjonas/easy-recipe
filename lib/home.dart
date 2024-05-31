import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:easy_recipe/models/recipe.api.dart';
import 'package:easy_recipe/recipe_card.dart';

import 'filter_option.dart';
import 'models/recipe.dart';

//TODO: Add colors as variables to reduce redundancy

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  late List<Recipe> _recipes = [];
  int randomRecipeCount = 5;
  bool _isLoading = true;

  int currentPageIndex = 1;
  NavigationDestinationLabelBehavior labelBehavior =
      NavigationDestinationLabelBehavior.onlyShowSelected;

  static final List<FilterOption> _filterOptions = [
    FilterOption(id: 0, name: '30min'),
    FilterOption(id: 1, name: '45min'),
    FilterOption(id: 2, name: '60min'),
    FilterOption(id: 3, name: 'more than 60min'),
    FilterOption(id: 4, name: 'vegetarian'),
    FilterOption(id: 5, name: 'vegan'),
    FilterOption(id: 6, name: 'dairy-free'),
    FilterOption(id: 7, name: 'gluten-free'),
    FilterOption(id: 8, name: 'ketogenic'),
    FilterOption(id: 9, name: 'breakfast'),
    FilterOption(id: 10, name: 'lunch'),
    FilterOption(id: 11, name: 'dinner'),
    FilterOption(id: 12, name: 'appetizer'),
    FilterOption(id: 13, name: 'main dish'),
    FilterOption(id: 14, name: 'side dish'),
    FilterOption(id: 15, name: 'snack'),
  ];

  final _items = _filterOptions
      .map((filterOption) => MultiSelectItem<FilterOption>(filterOption, filterOption.name))
      .toList();

  List<FilterOption> _selectedFilterOptions = [];

  @override
  void initState() {
    _selectedFilterOptions = [];
    getRecipes();
    super.initState();
  }

  Future<void> getRecipes() async {
    _recipes = await RecipeApi().getRandomRecipes(randomRecipeCount);
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
            });
          },
          maxChildSize: 0.8,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Top Search Bar
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Center(
          child: Text('EasyRecipe',
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        automaticallyImplyLeading: false,
      ),

      //Content
      body: Column(
        children: [
          Container(
            color: Theme.of(context).colorScheme.primary,
            padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
            child: Row(
              children: <Widget>[
                const Expanded(
                  child: TextField(
                    style: TextStyle(
                      height: 1.0,
                      color: Color(0xFF8D8D8D),
                    ),
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: 'Search',
                      hintStyle: TextStyle(
                        color: Color(0xFF8D8D8D),
                      ),
                      filled: true,
                      fillColor: Color(0xFFFFFFFF),
                      border: OutlineInputBorder(),
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
                          color: Color(0xFF3D3D3D)
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
              itemCount: randomRecipeCount,
              itemBuilder: (context, index) {
                final recipe = _recipes[index];
                
                // ensures special characters in the title are displayed properly
                String decodedTitle = RecipeApi().decodeSpecialCharacters(recipe.title);
                return RecipeCard(
                  title: decodedTitle,
                  cookingTime: recipe.cookingTime,
                  thumbnailUrl: recipe.image,
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
      //Navigation
      bottomNavigationBar: Container(
        color: Theme.of(context).colorScheme.primary,
        padding: const EdgeInsets.fromLTRB(0.0, 4.0, 0.0, 4.0),
        child: BottomNavigationBar(
          elevation: 0.0,
          type: BottomNavigationBarType.shifting,
          showUnselectedLabels: false,
          currentIndex: currentPageIndex,
          onTap: (int index) {
            setState(() {
              currentPageIndex = index;
            });
          },
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              backgroundColor: Theme.of(context).colorScheme.primary,
              icon: const Icon(
                Icons.book,
                color: Color(0xFFFFFFFF),
              ),
              label: 'My Recipes',
            ),
            BottomNavigationBarItem(
              backgroundColor: Theme.of(context).colorScheme.primary,
              icon: const Icon(
                Icons.home,
                color: Color(0xFFFFFFFF),
              ),
              label: 'Home',
            ),
          BottomNavigationBarItem(
              backgroundColor: Theme.of(context).colorScheme.primary,
              icon: const Icon(
                Icons.person,
                color: Color(0xFFFFFFFF),
              ),
              label: 'Profile',
            ),
          ],
        ),
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}
