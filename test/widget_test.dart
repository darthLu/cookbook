import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'package:cookbook/main.dart';

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
}
