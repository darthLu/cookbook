import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:cookbook/models/recipe.dart';
import 'package:cookbook/screens/recipe_detail_screen.dart';
import 'package:cookbook/screens/meal_planning_screen.dart';
import 'package:cookbook/services/meal_plan_service.dart';

void main() {
  late Directory directory;
  final service = MealPlanService.instance;
  Recipe recipe() => Recipe(
    id: 'pasta',
    name: 'Pasta',
    description: 'Dinner',
    ingredients: ['Pasta'],
    steps: ['Boil'],
    cookTime: '10 min',
    category: 'Dinner',
  );

  setUp(() async {
    directory = await Directory.systemTemp.createTemp('cookbook_plan_');
    Hive.init(directory.path);
  });
  tearDown(() async {
    await Hive.close();
    await directory.delete(recursive: true);
  });

  test(
    'Weekday plans persist, avoid duplicates, and follow recipe updates/deletion',
    () async {
      await service.add('Monday', recipe());
      await service.add('Monday', recipe());
      await service.add('Friday', recipe());
      await service.saveNote('Monday', 'Leftovers');
      await Hive.close();
      expect(await service.noteFor('Monday'), 'Leftovers');
      expect(await service.noteFor('Tuesday'), isEmpty);
      expect((await service.recipesFor('Monday')).single.name, 'Pasta');
      expect(await service.recipesFor('Tuesday'), isEmpty);
      final updated = recipe()..name = 'Fresh pasta';
      await service.updateRecipe(updated);
      expect((await service.recipesFor('Friday')).single.name, 'Fresh pasta');
      await service.remove('Monday', 0);
      expect(await service.recipesFor('Monday'), isEmpty);
      await service.deleteRecipe('pasta');
      expect(await service.recipesFor('Friday'), isEmpty);
      expect(await service.noteFor('Monday'), 'Leftovers');
      await service.saveNote('Monday', '');
      expect(await service.noteFor('Monday'), isEmpty);
    },
  );

  testWidgets(
    'Recipe detail assigns a weekday and meal plan shows and removes it',
    (tester) async {
      await tester.runAsync(() async {
        await Hive.openBox('mealPlan');
      });
      await tester.pumpWidget(
        MaterialApp(home: RecipeDetailScreen(recipe: recipe())),
      );
      await tester.tap(find.byTooltip('Add to meal plan'));
      await tester.pumpAndSettle();
      expect(find.text('Saturday'), findsNothing);
      expect(find.text('Sunday'), findsNothing);
      await tester.runAsync(() async {
        await tester.tap(find.text('Tuesday'));
        await Future<void>.delayed(const Duration(milliseconds: 100));
      });
      await tester.pumpAndSettle();
      await tester.runAsync(() async {
        expect((await service.recipesFor('Tuesday')).single.name, 'Pasta');
        await tester.pumpWidget(const MaterialApp(home: MealPlanningScreen()));
        await Future<void>.delayed(const Duration(milliseconds: 100));
      });
      await tester.pumpAndSettle();
      final meal = find.widgetWithText(ListTile, 'Pasta');
      expect(meal, findsOneWidget);
      await tester.ensureVisible(meal);
      await tester.runAsync(() async {
        await tester.tap(find.byTooltip('Remove Pasta from Tuesday'));
        await Future<void>.delayed(const Duration(milliseconds: 100));
        expect(await service.recipesFor('Tuesday'), isEmpty);
      });
      await tester.pumpAndSettle();
      await tester.pumpWidget(const SizedBox());
    },
  );
}
