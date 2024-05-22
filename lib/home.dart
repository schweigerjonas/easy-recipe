import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPageIndex = 1;
  NavigationDestinationLabelBehavior labelBehavior =
      NavigationDestinationLabelBehavior.onlyShowSelected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Content
      body: const Center(
        child: Text('Home Page'),
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
                color: const Color(0xFF367D5F),
            ),
            label: 'Meine Rezepte',
          ),
          NavigationDestination(
            icon: Icon(
                Icons.home,
                color: const Color(0xFF367D5F),
            ),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(
                Icons.person,
                color: const Color(0xFF367D5F),
            ),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
