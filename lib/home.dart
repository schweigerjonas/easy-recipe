import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:easy_recipe/models/recipe.api.dart';
import 'package:easy_recipe/recipe_card.dart';

import 'filter_option.dart';
import 'models/recipe.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Recipe> _recipes = [];
  int randomRecipeCount = 0;
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
        title: const Center(
          child: Text('EasyRecipe'),
        ),
        //backgroundColor: const Color(0xFF4CAD85),
        automaticallyImplyLeading: false,
      ),

      //Content
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0.0),
            child: Row(
              children: <Widget>[
                const Expanded(
                  child: TextField(
                    style: TextStyle(height: 1),
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: 'Search',
                      border: OutlineInputBorder(),
                      fillColor: Color(0xFFFFFFFF),
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                ElevatedButton(
                  onPressed: () {
                    _showMultiSelect(context);
                  },
                  child:
                      const Icon(Icons.filter_list, color: Color(0xFF367D5F)),
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
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold
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
        child: const Icon(Icons.add),
        onPressed: () {

        },
      ),
      //Navigation
      bottomNavigationBar: NavigationBar(
        labelBehavior: labelBehavior,
        selectedIndex: currentPageIndex,
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(
              Icons.book,
              color: Color(0xFF367D5F),
            ),
            label: 'My Recipes',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.home,
              color: Color(0xFF367D5F),
            ),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.person,
              color: Color(0xFF367D5F),
            ),
            label: 'Profile',
          ),
        ],
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}
