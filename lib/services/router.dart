import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../views/my_home_page.dart';

final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/sign-in',
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: const Color(0xffe0e0e0),
            title: IconButton(
              onPressed: () {
                context.pushReplacement('/');
              },
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: Color(0xFF3D3D3D),
              ),
            ),
            automaticallyImplyLeading: false,
          ),
          body: SignInScreen(
            actions: [
              ForgotPasswordAction(((context, email) {
                final uri = Uri(
                  path: '/sign-in/forgot-password',
                  queryParameters: <String, String?>{
                    'email': email,
                  },
                );
                context.push(uri.toString());
              })),
              AuthStateChangeAction(((context, state) {
                final user = switch (state) {
                  SignedIn state => state.user,
                  UserCreated state => state.credential.user,
                  _ => null
                };
                if (user == null) {
                  return;
                }
                if (state is UserCreated) {
                  user.updateDisplayName(user.email!.split('@')[0]);
                }
                if (!user.emailVerified) {
                  user.sendEmailVerification();
                  const snackBar = SnackBar(
                    content: Text(
                        'Please check your email to verify your email address.'
                    ),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
                context.pushReplacement('/');
              })),
            ],
          ),
        );
      },
      routes: [
        GoRoute(
          path: 'forgot-password',
          builder: (context, state) {
            final arguments = state.uri.queryParameters;
            return ForgotPasswordScreen(
              email: arguments['email'],
              headerMaxExtent: 200,
            );
          },
        ),
      ],
    ),
    GoRoute(
      path: '/',
      builder: (context, state) {
        return const MyHomePage();
      },
    ),
  ],
);

GoRouter getRouter() {
  return _router;
}