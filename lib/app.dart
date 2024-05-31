import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'home.dart';

class RecipeApp extends StatelessWidget {
  const RecipeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Easy Recipe',
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
}

class MyHomePage extends StatefulWidget {
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
        page = const Placeholder();
        break;
      case 1:
        page = const HomePage();
        break;
      case 2:
        page = const Placeholder();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    return LayoutBuilder(builder: (context, constraints) {
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
        body: page,
        //Navigation
        bottomNavigationBar: NavigationBar(
          destinations: const <Widget>[
            NavigationDestination(
              icon: Icon(
                Icons.book,
                color: Color(0xFF367D5F),
              ),
              label: 'Meine Rezepte',
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
              label: 'Profil',
            ),
          ],
          selectedIndex: selectedIndex,
          onDestinationSelected: (value) {
            setState(() {
              selectedIndex = value;
            });
          },
        ),
        resizeToAvoidBottomInset: false,
      );
    });
  }
}