import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AuthFunc extends StatelessWidget {
  const AuthFunc({
    super.key,
    required this.loggedIn,
    required this.signOut,
    required this.toggleState
  });

  final bool loggedIn;
  final void Function() signOut;
  final VoidCallback toggleState;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: !loggedIn ? const Icon(Icons.login) : const Icon(Icons.logout),
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.secondary,
      ),
      onPressed: () {
        toggleState();
        !loggedIn ? context.push('/sign-in') : signOut();
      },
      label: !loggedIn ? const Text('Sign In') : const Text('Logout'),
    );
  }
}