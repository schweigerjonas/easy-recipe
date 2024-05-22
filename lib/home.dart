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
      //Top Search Bar
      appBar: AppBar(
        title: const Center(
          child: Text('EasyRecipe'),
        ),
        //backgroundColor: const Color(0xFF4CAD85),
        automaticallyImplyLeading: false,
      ),

      //Content
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 24.0),
            child: Row(
              children: <Widget>[
                const Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      icon: Icon(Icons.search),
                      hintText: 'Suche',
                      border: OutlineInputBorder(),
                      fillColor: Color(0xFFFFFFFF),
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                ElevatedButton(
                  onPressed: () {

                  },
                  child: const Icon(
                      Icons.filter_list,
                      color: Color(0xFF367D5F)
                  ),
                ),
              ],
            ),
          ),
          
        ],

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
      ),
    );
  }
}
