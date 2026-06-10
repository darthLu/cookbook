import 'package:hive_flutter/hive_flutter.dart';
import '../models/recipe.dart';

class RecipeStorage {
  static const String boxName = 'recipes';

  static Future<void> saveRecipes(List<Recipe> recipes) async {
    final box = await Hive.openBox(boxName);

    final recipeMaps = recipes.map((recipe) {
      return {
        'name': recipe.name,
        'cookTime': recipe.cookTime,
        'description': recipe.description,
        'ingredients': recipe.ingredients,
        'steps': recipe.steps,
        'category': recipe.category,
      };
    }).toList();

    await box.put('recipeList', recipeMaps);
  }

  static Future<List<Recipe>> loadRecipes() async {
    final box = await Hive.openBox(boxName);

    final data = box.get('recipeList');

    if (data == null) {
      return [];
    }

    return (data as List).map((item) {
      return Recipe(
        name: item['name'],
        cookTime: item['cookTime'],
        description: item['description'],
        ingredients: List<String>.from(item['ingredients']),
        steps: List<String>.from(item['steps']),
        category: item['category'] ?? 'Dinner', // Load the category from Hive
      );
    }).toList();
  }
}