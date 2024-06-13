import 'package:easy_recipe/views/profile.dart';
import 'package:flutter/material.dart';

import 'create_recipe.dart';
import 'home.dart';
import 'my_recipe_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<StatefulWidget> createState() =>
      _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = const MyRecipePage();
        break;
      case 1:
        page = const HomePage();
        break;
      case 2:
        page = const ProfilePage();
        break;
      case 3:
        page = const CreateRecipePage();
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    return LayoutBuilder(builder: (context, constraints) {
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
        body: page,
        //Navigation
        bottomNavigationBar: Container(
          color: Theme.of(context).colorScheme.primary,
          padding: const EdgeInsets.fromLTRB(0.0, 4.0, 0.0, 4.0),
          child: BottomNavigationBar(
            elevation: 0.0,
            type: BottomNavigationBarType.shifting,
            showUnselectedLabels: false,
            currentIndex: selectedIndex,
            onTap: (int index) {
              setState(() {
                selectedIndex = index;
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
    });
  }
}