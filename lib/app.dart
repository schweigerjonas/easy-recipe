import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'home.dart';

class EasyRecipeApp extends StatelessWidget {
  const EasyRecipeApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EasyRecipe',
      initialRoute: '/',
      routes: {
        '/': (BuildContext context) => const HomePage(),
      },
    );
  }
}