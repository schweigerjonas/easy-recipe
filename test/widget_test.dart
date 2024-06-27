// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:easy_recipe/models/creation_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final model = CreationModel();
  test('cooking time should be set to 45 minutes', () {
    
    model.setTimeToCook(45);

    expect(model.cookingTime, 45);
  });
  test('index should be set to 1', () {
    
    model.setPageIndex(1);

    expect(model.currentPageIndex, 1);
  });
}
