import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cookbook/main.dart';

void main() {
  testWidgets('Cookbook app shows splash screen', (WidgetTester tester) async {
    await tester.pumpWidget(const CookbookApp());

    expect(find.byIcon(Icons.menu_book), findsOneWidget);
    expect(find.text('Cookbook'), findsOneWidget);
    expect(find.text('Lindseys Cookbook'), findsOneWidget);
  });
}
