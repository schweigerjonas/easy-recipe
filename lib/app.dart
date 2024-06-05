import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider, PhoneAuthProvider;
import 'package:easy_recipe/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'home.dart';
// import 'login.dart';

final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/sign-in',
      builder: (context, state) {
        return SignInScreen(
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
      path: '/profile',
      builder: (context, state) {
        return ProfileScreen(
          providers: const [],
          actions: [
            SignedOutAction((context) {
              context.pushReplacement('/');
            }),
          ],
        );
      },
    ),
    GoRoute(
      path: '/',
      builder: (context, state) {
        return const MyHomePage();
      },
    ),
  ],
);

class RecipeApp extends StatelessWidget {
  const RecipeApp({super.key});

  @override
  Widget build(BuildContext context) {
      return ChangeNotifierProvider(
        create: (context) => ApplicationState(),
        child: MaterialApp.router(
          title: 'Easy Recipe',
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF419873),
              primary: const Color(0xFF419873),
              secondary: const Color(0xFFFF574D),
            ),
          ),
          routerConfig: _router,
        ),
      );
  }
}

class ApplicationState extends ChangeNotifier {
  ApplicationState() {
    init();
  }

  bool _loggedIn = false;
  bool get loggedIn => _loggedIn;

  Future<void> init() async {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

    FirebaseUIAuth.configureProviders([
      EmailAuthProvider(),
    ]);

    FirebaseAuth.instance.userChanges().listen((user) {
      if (user != null) {
        _loggedIn = true;
      } else {
        _loggedIn = false;
      }
      notifyListeners();
    });
  }
}

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