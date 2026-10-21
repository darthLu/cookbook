import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/recipe.dart';
import 'meal_plan_service.dart';

class RecipeFirestoreService {
  static final changes = ValueNotifier<int>(0);
  static Future<List<Recipe>> loadRecipes() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('recipes')
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();

      return Recipe(
        id: doc.id,
        name: data['name'] ?? '',
        cookTime: data['cookTime'] ?? '',
        description: data['description'] ?? '',
        ingredients: List<String>.from(data['ingredients'] ?? []),
        steps: List<String>.from(data['steps'] ?? []),
        category: data['category'] ?? 'Uncategorized',
      );
    }).toList();
  }

  static Future<void> addRecipe(Recipe recipe) async {
    await FirebaseFirestore.instance.collection('recipes').add({
      'name': recipe.name,
      'cookTime': recipe.cookTime,
      'description': recipe.description,
      'ingredients': recipe.ingredients,
      'steps': recipe.steps,
      'category': recipe.category,
    });
  }

  static Future<void> updateRecipe(Recipe recipe) async {
    await FirebaseFirestore.instance
        .collection('recipes')
        .doc(recipe.id)
        .update({
          'name': recipe.name,
          'description': recipe.description,
          'ingredients': recipe.ingredients,
          'steps': recipe.steps,
          'cookTime': recipe.cookTime,
          'category': recipe.category,
        });
    await MealPlanService.instance.updateRecipe(recipe);
    changes.value++;
  }

  static Future<void> deleteRecipe(String id) async {
    await FirebaseFirestore.instance.collection('recipes').doc(id).delete();
    await MealPlanService.instance.deleteRecipe(id);
  }
}
