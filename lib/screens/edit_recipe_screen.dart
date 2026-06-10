import 'package:flutter/material.dart';
import '../models/recipe.dart';

class EditRecipeScreen extends StatefulWidget {
  const EditRecipeScreen({super.key});

  @override
  State<EditRecipeScreen> createState() => _EditRecipeScreenState();
}

class _EditRecipeScreenState extends State<EditRecipeScreen> {
  final nameController = TextEditingController();
  final cookTimeController = TextEditingController();
  final descriptionController = TextEditingController();
  final ingredientsController = TextEditingController();
  final stepsController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    cookTimeController.dispose();
    descriptionController.dispose();
    ingredientsController.dispose();
    stepsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Recipe'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Recipe Name'),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: cookTimeController,
              decoration: const InputDecoration(labelText: 'Cook Time'),
            ),

            const SizedBox(height: 16),
            
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: ingredientsController,
              maxLines: 6,
              decoration: const InputDecoration(
                labelText: 'Ingredients',
                hintText: 'One ingredient per line',
                //border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: stepsController,
              maxLines: 8,
              decoration: const InputDecoration(
                labelText: 'Steps',
                hintText: 'One step per line',
                //border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            ElevatedButton(
              onPressed: () {
                final recipe = Recipe(
                  name: nameController.text,
                  cookTime: cookTimeController.text,
                  description: descriptionController.text,
                  ingredients: ingredientsController.text.split('\n').where((item) => item.trim().isNotEmpty).toList(),
                  steps: stepsController.text.split('\n').where((item) => item.trim().isNotEmpty).toList(),
                );
                Navigator.pop(context, recipe);
              },
              child: const Text('Save Recipe'),
            ),
          ],
        ),
      ),
      ),
    );
  }
}
