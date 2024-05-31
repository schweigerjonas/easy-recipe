import 'package:flutter/material.dart';

import 'home.dart';

class EasyRecipeApp extends StatelessWidget {
  const EasyRecipeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF419873),
          primary: const Color(0xFF419873),
          secondary: const Color(0xFFFF574D),
        ),
      ),
      title: 'EasyRecipe',
      initialRoute: '/',
      routes: {
        '/': (BuildContext context) => const HomePage(),
      },
    );
  }
}