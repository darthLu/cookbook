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

  @override
  void dispose() {
    nameController.dispose();
    cookTimeController.dispose();
    descriptionController.dispose();
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

            ElevatedButton(
              onPressed: () {
                final recipe = Recipe(
                  name: nameController.text,
                  cookTime: cookTimeController.text,
                  description: descriptionController.text,
                  ingredients: [],
                  steps: [],
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
