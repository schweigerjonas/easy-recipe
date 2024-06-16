import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginRequiredPage extends StatelessWidget {
  const LoginRequiredPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AlertDialog(
        title: const Text('Login required'),
        content: const Text('You need to be logged in to do this!'),
        actions: [
          TextButton(
              onPressed: () {
                context.go("/sign-in");
              },
              child: const Text('LOGIN')
          ),
        ],
      ),
    );
  }

}