import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/recipe.dart';

class MealPlanService extends ChangeNotifier {
  MealPlanService._();
  static final instance = MealPlanService._();
  static const weekdays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
  ];
  Future<Box<dynamic>> get _box => Hive.openBox('mealPlan');

  Future<String> noteFor(String day) async {
    final box = await _box;
    return box.get('note:$day', defaultValue: '') as String;
  }

  Future<void> saveNote(String day, String note) async {
    if (!weekdays.contains(day)) throw ArgumentError.value(day, 'day');
    final box = await _box;
    await box.put('note:$day', note.trim());
  }

  Future<List<Recipe>> recipesFor(String day) async {
    final box = await _box;
    return (box.get(day, defaultValue: <dynamic>[]) as List)
        .map(
          (item) => Recipe(
            id: item['id'],
            name: item['name'],
            description: item['description'],
            ingredients: List<String>.from(item['ingredients']),
            steps: List<String>.from(item['steps']),
            cookTime: item['cookTime'],
            category: item['category'],
          ),
        )
        .toList();
  }

  Future<void> _save(String day, List<Recipe> recipes) async {
    final box = await _box;
    await box.put(
      day,
      recipes
          .map(
            (r) => {
              'id': r.id,
              'name': r.name,
              'description': r.description,
              'ingredients': r.ingredients,
              'steps': r.steps,
              'cookTime': r.cookTime,
              'category': r.category,
            },
          )
          .toList(),
    );
    notifyListeners();
  }

  Future<void> add(String day, Recipe recipe) async {
    if (!weekdays.contains(day)) throw ArgumentError.value(day, 'day');
    final recipes = await recipesFor(day);
    if (recipes.any(
      (r) => recipe.id != null ? r.id == recipe.id : r.name == recipe.name,
    )) {
      return;
    }
    await _save(day, [...recipes, recipe]);
  }

  Future<void> remove(String day, int index) async {
    final recipes = await recipesFor(day);
    recipes.removeAt(index);
    await _save(day, recipes);
  }

  Future<void> updateRecipe(Recipe recipe) async {
    if (recipe.id == null) return;
    for (final day in weekdays) {
      final recipes = await recipesFor(day);
      if (recipes.any((r) => r.id == recipe.id)) {
        await _save(
          day,
          recipes.map((r) => r.id == recipe.id ? recipe : r).toList(),
        );
      }
    }
  }

  Future<void> deleteRecipe(String id) async {
    for (final day in weekdays) {
      final recipes = await recipesFor(day);
      if (recipes.any((r) => r.id == id)) {
        await _save(day, recipes.where((r) => r.id != id).toList());
      }
    }
  }
}
