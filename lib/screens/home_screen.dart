import 'package:flutter/material.dart';
import '../data/recipes.dart';
import 'recipe_detail_screen.dart';
import 'edit_recipe_screen.dart';
import '../models/recipe.dart';
import '../services/recipe_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/recipe_firestore_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String searchQuery = '';
  String selectedCategory = 'All';
  List<Recipe> recipes = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRecipes();
  }

  Future<void> _loadRecipes() async {
    final firestoreRecipes = await RecipeFirestoreService.loadRecipes();

    setState(() {
      recipes = firestoreRecipes;
      isLoading = false;
    });
  }

  void _showDeleteDialog(Recipe recipe) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Recipe'),
          content: Text('Delete "${recipe.name}"?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (recipe.id != null) {
                  await RecipeFirestoreService.deleteRecipe(recipe.id!);
                }

                await _loadRecipes();

                if (mounted) {
                  Navigator.pop(context);
                }
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final categories = ['All', ...recipes.map((r) => r.category).toSet()];

    final filteredRecipes = recipes.where((recipe) {
      final matchesSearch = recipe.name.toLowerCase().contains(
        searchQuery.toLowerCase(),
      );

      final matchesCategory =
          selectedCategory == 'All' || recipe.category == selectedCategory;

      return matchesSearch && matchesCategory;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F0E8),
      appBar: AppBar(
        title: const Text(
          'Cookbook',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        backgroundColor: const Color.fromARGB(255, 5, 106, 23),
        foregroundColor: Colors.white,
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 5, 106, 23),
        foregroundColor: Colors.white,
        onPressed: () async {
          final newRecipe = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const EditRecipeScreen()),
          );

          if (newRecipe != null) {
            await RecipeFirestoreService.addRecipe(newRecipe);

            await _loadRecipes();
          }
        },
        child: const Icon(Icons.add),
      ),

      body: Column(
        children: [
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];

                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(category),
                    selected: selectedCategory == category,
                    onSelected: (_) {
                      setState(() {
                        selectedCategory = category;
                      });
                    },
                  ),
                );
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search recipes...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
          ),

          Expanded(
            child: filteredRecipes.isEmpty
                ? const Center(
                    child: Text(
                      'No recipes found',
                      style: TextStyle(fontSize: 18),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filteredRecipes.length,
                    itemBuilder: (context, index) {
                      final recipe = filteredRecipes[index];

                      return Card(
                        color: const Color(0xFFFDF6EC),
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          title: Text(
                            recipe.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Color.fromARGB(255, 0, 18, 4),
                            ),
                          ),
                          subtitle: Text(
                            '${recipe.category} • ⏱ ${recipe.cookTime}\n${recipe.description}',
                            style: const TextStyle(
                              color: Color.fromARGB(255, 3, 57, 13),
                            ),
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            color: Color(0xFF8B5E3C),
                            size: 16,
                          ),
                          onTap: () async {
                            final updatedRecipe = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    RecipeDetailScreen(recipe: recipe),
                              ),
                            );

                            if (updatedRecipe != null) {
                              await RecipeFirestoreService.updateRecipe(
                                updatedRecipe,
                              );

                              await _loadRecipes();
                            }
                          },
                          onLongPress: () {
                            _showDeleteDialog(recipe);
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
