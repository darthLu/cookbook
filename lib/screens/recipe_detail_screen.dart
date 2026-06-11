import 'package:flutter/material.dart';
import '../models/recipe.dart';
import 'edit_recipe_screen.dart';

class RecipeDetailScreen extends StatelessWidget {
  final Recipe recipe;
  const RecipeDetailScreen({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final updatedRecipe = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditRecipeScreen(recipe: recipe),
            ),
          );

          if (updatedRecipe != null) {
            // ignore: use_build_context_synchronously
            Navigator.pop(context, updatedRecipe);
          }
        },
        child: const Icon(Icons.edit),
      ),

      backgroundColor: const Color(0xFFF5F0E8),
      appBar: AppBar(
        title: Text(recipe.name),
        backgroundColor: const Color.fromARGB(255, 5, 106, 23),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              recipe.description,
              style: const TextStyle(
                fontSize: 16,
                color: Color.fromARGB(255, 14, 75, 31),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '⏱ Cook time: ${recipe.cookTime}',
              style: const TextStyle(
                fontSize: 14,
                color: Color.fromARGB(255, 54, 119, 60),
              ),
            ),
            const Divider(height: 32, color: Color.fromARGB(255, 7, 26, 10)),

            const Text(
              'Ingredients',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 26, 74, 35),
              ),
            ),
            const SizedBox(height: 8),
            ...recipe.ingredients.map(
              (ingredient) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    const Text(
                      '• ',
                      style: TextStyle(
                        color: Color.fromARGB(255, 26, 74, 35),
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      ingredient,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Color.fromARGB(255, 26, 74, 35),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Divider(height: 32, color: Color.fromARGB(255, 7, 26, 10)),

            const Text(
              'Steps',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 26, 74, 35),
              ),
            ),
            const SizedBox(height: 8),
            ...recipe.steps.asMap().entries.map(
              (entry) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${entry.key + 1}.  ',
                      style: const TextStyle(
                        color: Color.fromARGB(255, 26, 74, 35),
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        entry.value,
                        style: const TextStyle(
                          fontSize: 15,
                          color: Color.fromARGB(255, 26, 74, 35),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}