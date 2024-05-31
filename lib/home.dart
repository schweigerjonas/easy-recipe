import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:easy_recipe/models/recipe.api.dart';
import 'package:easy_recipe/models/recipe.dart';
import 'package:easy_recipe/recipe_card.dart';

import 'filter_option.dart';
import 'recipe_detail.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Recipe> _recipes;
  bool _isLoading = true;
  final searchController = TextEditingController();
  int currentPageIndex = 0;
  NavigationDestinationLabelBehavior labelBehavior =
      NavigationDestinationLabelBehavior.onlyShowSelected;

  static final List<FilterOption> _filterOptions = [
    FilterOption(id: 0, name: 'bis 20min'),
    FilterOption(id: 1, name: '20 bis 40min'),
    FilterOption(id: 2, name: '40 bis 60min'),
    FilterOption(id: 3, name: 'länger als 60min'),
    FilterOption(id: 4, name: '2 Portionen'),
    FilterOption(id: 5, name: '3 Portionen'),
    FilterOption(id: 6, name: '4 Portionen'),
    FilterOption(id: 7, name: 'vegetarisch'),
    FilterOption(id: 8, name: 'vegan'),
    FilterOption(id: 9, name: 'laktosefrei'),
    FilterOption(id: 10, name: 'glutenfrei'),
  ];

  final _items = _filterOptions
      .map((filterOption) => MultiSelectItem<FilterOption>(filterOption, filterOption.name))
      .toList();

  List<FilterOption> _selectedFilterOptions = [];

  @override
  void initState() {
    _selectedFilterOptions = [];
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    searchController.dispose();
    super.dispose();
  }

  Future<void> getRecipes(String name) async {
    _recipes = await RecipeApi.getRecipe(name);
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
    if (currentPageIndex == 0) {
      return Scaffold(
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      style: const TextStyle(height: 1),
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        hintText: 'Suche',
                        border: OutlineInputBorder(),
                        fillColor: Color(0xFFFFFFFF),
                      ),
                      controller: searchController,
                      onSubmitted: (String text) {
                        getRecipes(searchController.text);
                        currentPageIndex = 1;
                      },
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
            const Center(
              child: Text("noch keine Suche durchgeführt"),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {

          },
        ),
      );
    } else if (currentPageIndex == 1) {
      return Scaffold(
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0.0),
              child: Row(
                children: <Widget>[
                   Expanded(
                    child: TextField(
                      style: const TextStyle(height: 1),
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        hintText: 'Suche',
                        border: OutlineInputBorder(),
                        fillColor: Color(0xFFFFFFFF),
                      ),
                      controller: searchController,
                      onSubmitted: (String text) {
                        getRecipes(searchController.text);
                        currentPageIndex = 1;
                      },
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
                'Beliebte Rezepte',
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
                  itemCount: _recipes.length,
                  itemBuilder: (context, index) {
                    return RecipeCard(
                      title: _recipes[index].name,
                      cookTime: _recipes[index].totalTime,
                      rating: _recipes[index].rating.toString(),
                      thumbnailUrl: _recipes[index].images,
                      onTap: () {
                        setState(() {
                          currentPageIndex = 2;
                        });
                      },
                    );
                  },
                )
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {

          },
        ),
      );
    } else if (currentPageIndex == 2) {
      return RecipeDetailPage();
    } else {
      throw UnimplementedError('no widget for $currentPageIndex');
    }
  }
}
