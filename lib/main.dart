import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'application_state.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(ChangeNotifierProvider(
   create: (context) => ApplicationState(),
   builder: ((context, child) => const RecipeApp()),
  ));
}
