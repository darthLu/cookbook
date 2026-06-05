import 'package:flutter/material.dart';
import '../models/recipe.dart';

class RecipeDetailScreen extends StatelessWidget {
  final Recipe recipe;
  const RecipeDetailScreen({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0E8),
      appBar: AppBar(
        title: Text(recipe.name),
        backgroundColor: const Color(0xFF8B5E3C),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(recipe.description,
                style: const TextStyle(
                    fontSize: 16, color: Color(0xFF7A5C3E))),
            const SizedBox(height: 8),
            Text('⏱ Cook time: ${recipe.cookTime}',
                style: const TextStyle(
                    fontSize: 14, color: Color(0xFF8B5E3C))),
            const Divider(height: 32, color: Color(0xFFD4B896)),

            const Text('Ingredients',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4A2E1A))),
            const SizedBox(height: 8),
            ...recipe.ingredients.map((ingredient) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      const Text('• ',
                          style: TextStyle(
                              color: Color(0xFF8B5E3C), fontSize: 16)),
                      Text(ingredient,
                          style: const TextStyle(
                              fontSize: 15, color: Color(0xFF4A2E1A))),
                    ],
                  ),
                )),
            const Divider(height: 32, color: Color(0xFFD4B896)),

            const Text('Steps',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4A2E1A))),
            const SizedBox(height: 8),
            ...recipe.steps.asMap().entries.map((entry) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${entry.key + 1}.  ',
                          style: const TextStyle(
                              color: Color(0xFF8B5E3C),
                              fontWeight: FontWeight.bold,
                              fontSize: 15)),
                      Expanded(
                        child: Text(entry.value,
                            style: const TextStyle(
                                fontSize: 15, color: Color(0xFF4A2E1A))),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}