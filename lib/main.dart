import 'package:easy_recipe/models/home_model.dart';
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
      ],
      builder: ((context, child) => const RecipeApp()),
    ),
  );
}
