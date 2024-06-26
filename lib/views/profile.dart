import 'package:easy_recipe/models/my_recipe_page_model.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

import '../models/application_state.dart';
import 'authentication.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  void toggleLogin() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Consumer<ApplicationState>(
          builder: (context, appState, _) {
            return appState.loggedIn ? loggedInView(appState) : loggedOutView();
          },
        ),
      ),
    );
  }

  Widget loggedInView(ApplicationState appState) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: const BoxDecoration(
            color: Colors.grey,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            MdiIcons.food,
            color: Colors.white,
            size: 100 * 0.7, // Icon size relative to the container size
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'Welcome, User!',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Text(
          FirebaseAuth.instance.currentUser?.email ?? '',
          style: const TextStyle(fontSize: 16, color: Colors.grey),
        ),
        const SizedBox(height: 20),
        Container(
          alignment: Alignment.center,
          child: AuthFunc(
            loggedIn: appState.loggedIn,
            signOut: () {
              FirebaseAuth.instance.signOut();
              Provider.of<MyRecipePageModel>(context, listen: false).setRecipes([]);
              Provider.of<MyRecipePageModel>(context, listen: false).setRecipeIDs([]);
            },
            toggleState: toggleLogin,
          ),
        ),
      ],
    );
  }

  Widget loggedOutView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.account_circle,
          size: 100,
          color: Colors.grey,
        ),
        const SizedBox(height: 20),
        const Text(
          'You are not logged in',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        Container(
          alignment: Alignment.center,
          child: Consumer<ApplicationState>(
            builder: (context, appState, _) => AuthFunc(
              loggedIn: appState.loggedIn,
              signOut: () {
                FirebaseAuth.instance.signOut();
                Provider.of<MyRecipePageModel>(context, listen: false).setRecipes([]);
                Provider.of<MyRecipePageModel>(context, listen: false).setRecipeIDs([]);
              },
              toggleState: toggleLogin,
            ),
          ),
        ),
      ],
    );
  }
}