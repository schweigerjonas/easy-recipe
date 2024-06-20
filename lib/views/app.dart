import 'package:easy_recipe/views/profile.dart';
import 'package:easy_recipe/models/router.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/application_state.dart';

import 'create_recipe.dart';
import 'home.dart';
import 'my_recipe_page.dart';

class RecipeApp extends StatelessWidget {
  const RecipeApp({super.key});

  @override
  Widget build(BuildContext context) {
      return ChangeNotifierProvider(
        create: (context) => ApplicationState(),
        child: MaterialApp.router(
          title: 'Easy Recipe',
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF419873),
              primary: const Color(0xFF419873),
              secondary: const Color(0xFFFF574D),
            ),
          ),
          routerConfig: getRouter(),
        ),
      );
  }
}