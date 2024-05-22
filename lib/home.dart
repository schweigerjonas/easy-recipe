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

  List<Card> _buildRecipeCards(int count) {
    List<Card> cards = List.generate(
      count,
      (int index) {
        return const Card(
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: <Widget>[
              AspectRatio(
                aspectRatio: 18.0 / 11.0,
                //IMAGES ARE SHOWN IN THIS CONTAINER
                //child ,
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('TITLE'),
                    SizedBox(height: 8.0),
                    Text('SCHWIERIGKEIT | DAUER'),
                    SizedBox(height: 8.0),
                    Text('BESCHREIBUNG'),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
    return cards;
  }

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
                      prefixIcon: Icon(Icons.search),
                      hintText: 'Suche',
                      border: OutlineInputBorder(),
                      fillColor: Color(0xFFFFFFFF),
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                ElevatedButton(
                  onPressed: () {},
                  child:
                      const Icon(Icons.filter_list, color: Color(0xFF367D5F)),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 8.0),
            alignment: Alignment.centerLeft,
            child: const Text('Beliebte Rezepte'),
          ),
          Expanded(
            child: GridView.count(
              shrinkWrap: true,
              crossAxisCount: 1,
              padding: const EdgeInsets.all(16.0),
              childAspectRatio: 8.0 / 9.0,
              children: _buildRecipeCards(10),
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
      resizeToAvoidBottomInset: false,
    );
  }
}
