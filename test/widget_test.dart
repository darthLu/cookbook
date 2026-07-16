import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'package:cookbook/main.dart';
import 'package:cookbook/screens/edit_recipe_screen.dart';

void main() {
  testWidgets('Cookbook app shows splash screen', (WidgetTester tester) async {
    PackageInfo.setMockInitialValues(
      appName: 'Cookbook',
      packageName: 'com.lindseybarnard.cookbook',
      version: '1.0.0',
      buildNumber: '42',
      buildSignature: '',
    );

    await tester.pumpWidget(const CookbookApp());
    await tester.pump();

    expect(find.byIcon(Icons.menu_book), findsOneWidget);
    expect(find.text('Cookbook'), findsOneWidget);
    expect(find.text('Lindseys Cookbook'), findsOneWidget);
    expect(find.text('Version 1.0.0'), findsOneWidget);
  });

  testWidgets('Recipe description provides a multiline editing area', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: EditRecipeScreen()));

    final description = tester.widget<TextField>(
      find.widgetWithText(TextField, 'Description'),
    );

    expect(description.minLines, 4);
    expect(description.maxLines, 8);
    expect(description.maxLength, 250);
    expect(description.keyboardType, TextInputType.multiline);
  });

  testWidgets('Save recipe button remains visible without scrolling', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MaterialApp(home: EditRecipeScreen()));

    final saveButton = find.widgetWithText(ElevatedButton, 'Save Recipe');
    expect(saveButton, findsOneWidget);
    expect(tester.getBottomRight(saveButton).dy, lessThanOrEqualTo(844));
  });
}
