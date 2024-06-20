import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'views/app.dart';
import 'models/application_state.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(ChangeNotifierProvider(
   create: (context) => ApplicationState(),
   builder: ((context, child) => const RecipeApp()),
  ));
}
