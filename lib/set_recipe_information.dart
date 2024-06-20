import 'package:flutter/material.dart';
import 'package:multi_select_flutter/bottom_sheet/multi_select_bottom_sheet_field.dart';
import 'package:multi_select_flutter/chip_display/multi_select_chip_display.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';
import 'package:provider/provider.dart';

import 'creation_model.dart';

class Category {
  final int id;
  final String name;
  bool isSet;

  Category({
    required this.id,
    required this.name,
    required this.isSet,
  });

  @override
  toString() {
    return "id: $id, name: $name, isSet: $isSet";
  }
}

class SetRecipeInformation extends StatefulWidget {
  const SetRecipeInformation({super.key});

  @override
  State<SetRecipeInformation> createState() => _SetRecipeInformationState();
}

class _SetRecipeInformationState extends State<SetRecipeInformation> {
  final _formKeyName = GlobalKey<FormState>();
  final _formKeyServings = GlobalKey<FormState>();
  final _formKeyTime = GlobalKey<FormState>();
  final recipeNameController = TextEditingController();
  final servingsController = TextEditingController();
  final timeController = TextEditingController();

  static final List<Category> _categories = [
    Category(id: 1, name: "vegetarian", isSet: false),
    Category(id: 2, name: "vegan", isSet: false),
    Category(id: 3, name: "dairy-free", isSet: false),
    Category(id: 4, name: "gluten-free", isSet: false),
  ];
  final _items = _categories
      .map((category) => MultiSelectItem<Category>(category, category.name))
      .toList();
  List<Category?> _selectedCategories = [];

  @override
  void initState() {
    _selectedCategories = [];
    super.initState();
  }

  List<Category?> setCategoryValues() {
    for (var i=0; i<_selectedCategories.length; i++) {
      for (var j=0; j<_categories.length; j++) {
        if (_categories.elementAt(j).id == _selectedCategories.elementAt(i)?.id) {
          _categories.elementAt(j).isSet = true;
          break;
        }
      }
    }

    return _categories;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          const Text(
            'Create Recipe',
            textAlign: TextAlign.end,
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          const SizedBox(height: 32.0),
          Expanded(
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                const Text(
                  'Recipe Name',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
                Form(
                  key: _formKeyName,
                  child: TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'e.g. Pork Carnitas Tacos',
                    ),
                    controller: recipeNameController,
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'This field is required';
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
                const SizedBox(height: 24.0),
                const Text(
                  'Portions',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
                Row(
                  children: <Widget>[
                    const Text('The recipe is designed for '),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Form(
                          key: _formKeyServings,
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              hintText: 'e.g. 4',
                            ),
                            controller: servingsController,
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'This field is required';
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                    const Text(' servings/persons.'),
                  ],
                ),
                const SizedBox(height: 24.0),
                const Text(
                  'Cooking Time',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
                Row(
                  children: [
                    const Text('It takes '),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Form(
                          key: _formKeyTime,
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              hintText: 'e.g. 25',
                            ),
                            controller: timeController,
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return '';
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                    const Text('min. to cook the whole recipe.'),
                  ],
                ),
                const SizedBox(height: 24.0),
                const Text(
                  'Categories',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
                MultiSelectBottomSheetField<Category?>(
                  initialChildSize: 0.4,
                  listType: MultiSelectListType.CHIP,
                  buttonText: const Text('Select'),
                  title: const Text('Categories'),
                  items: _items,
                  onConfirm: (values) {
                    setState(() {
                      _selectedCategories = values;
                    });
                  },
                  chipDisplay: MultiSelectChipDisplay(
                    onTap: (value) {
                      setState(() {
                        _selectedCategories.remove(value);
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Consumer<CreationModel>(
                builder: (context, creation, _) => ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                  ),
                  onPressed: () {
                    if (_formKeyName.currentState!.validate() && _formKeyServings.currentState!.validate() && _formKeyTime.currentState!.validate()) {
                      creation.setRecipeTitle(recipeNameController.text);
                      creation.setServings(int.parse(servingsController.text));
                      creation.setTimeToCook(int.parse(timeController.text));
                      var categories = setCategoryValues();
                      creation.setCategories(categories);
                      creation.setPageIndex(1);
                    }
                  },
                  child: const Text('Next Step'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
