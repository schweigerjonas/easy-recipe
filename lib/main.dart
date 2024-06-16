import 'package:easy_recipe/models/home_model.dart';
import 'package:easy_recipe/models/my_recipe_page_model.dart';
import 'package:easy_recipe/models/recipe_card_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'views/app.dart';
import 'models/application_state.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ApplicationState(),
        ),
        ChangeNotifierProvider(
            create: (context) => HomePageModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => MyRecipePageModel(),
        ),
        ChangeNotifierProvider(
            create: (context) => RecipeCardModel()),
      ],
      builder: ((context, child) => const RecipeApp()),
    ),
  );
}
