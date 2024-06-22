import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import '../models/application_state.dart';
import 'authentication.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  late bool isLoggedIn;

  void toggleLogin() {
    setState(() {
      isLoggedIn = !isLoggedIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    isLoggedIn = Provider.of<ApplicationState>(context, listen: false).loggedIn;

    return Scaffold(
      body: Center(
        child: isLoggedIn ? loggedInView() : loggedOutView(),
      ),
    );
  }

  Widget loggedInView() {
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
          'Welcome, User!',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Text(
          FirebaseAuth.instance.currentUser?.email as String,
          style: const TextStyle(fontSize: 16, color: Colors.grey),
        ),
        const SizedBox(height: 20),
        Container(
          alignment: Alignment.center,
          child: Consumer<ApplicationState>(
            builder: (context, appState, _) => AuthFunc(
              loggedIn: appState.loggedIn,
              signOut: () {
                FirebaseAuth.instance.signOut();
              },
              toggleState: toggleLogin,
            ),
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
              },
              toggleState: toggleLogin,
            ),
          ),
        ),
      ],
    );
  }
}