import 'package:flutter/material.dart';
import '../data/recipes.dart';
import 'recipe_detail_screen.dart';
import 'edit_recipe_screen.dart';
import '../models/recipe.dart';
import '../services/recipe_storage.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String searchQuery = '';
  List<Recipe> recipes = [];
  bool isLoading = true;
  //  late List<Recipe> recipes;

  @override
  void initState() {
    super.initState();
    _loadRecipes();
  }

  Future<void> _loadRecipes() async {
    final savedRecipes = await RecipeStorage.loadRecipes();

    setState(() {
      recipes = savedRecipes.isEmpty ? List.from(sampleRecipes) : savedRecipes;

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
              onPressed: () {
                setState(() {
                  recipes.remove(recipe);
                  RecipeStorage.saveRecipes(recipes);
                });

                Navigator.pop(context);
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
    final filteredRecipes = recipes.where((recipe) {
      return recipe.name.toLowerCase().contains(searchQuery.toLowerCase());
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
            setState(() {
              recipes.add(newRecipe);
              RecipeStorage.saveRecipes(recipes);
            });
          }
        },
        child: const Icon(Icons.add),
      ),

      body: Column(
        children: [
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
                            '⏱ ${recipe.cookTime}  •  ${recipe.description}',
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
                              setState(() {
                                final recipeIndex = recipes.indexOf(recipe);

                                if (recipeIndex != -1) {
                                  recipes[recipeIndex] = updatedRecipe;
                                }
                              });

                              await RecipeStorage.saveRecipes(recipes);
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