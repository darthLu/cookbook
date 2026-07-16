import 'package:flutter/material.dart';
import '../models/recipe.dart';

class EditRecipeScreen extends StatefulWidget {
  final Recipe? recipe;

  const EditRecipeScreen({super.key, this.recipe});

  @override
  State<EditRecipeScreen> createState() => _EditRecipeScreenState();
}

class _EditRecipeScreenState extends State<EditRecipeScreen> {
  final nameController = TextEditingController();
  final cookTimeController = TextEditingController();
  final descriptionController = TextEditingController();
  final ingredientsController = TextEditingController();
  final stepsController = TextEditingController();
  String selectedCategory = 'Dinner';

  final categories = [
    'Breakfast',
    'Lunch',
    'Dinner',
    'Soup',
    'Dessert',
    'Side Dish',
    'Sauce',
  ];

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
  void initState() {
    super.initState();

    if (widget.recipe != null) {
      nameController.text = widget.recipe!.name;
      cookTimeController.text = widget.recipe!.cookTime;
      descriptionController.text = widget.recipe!.description;
      ingredientsController.text = widget.recipe!.ingredients.join('\n');
      stepsController.text = widget.recipe!.steps.join('\n');
      selectedCategory = widget.recipe!.category;
    }
  }

  void _saveRecipe() {
    final recipe = Recipe(
      id: widget.recipe?.id,
      name: nameController.text,
      cookTime: cookTimeController.text,
      description: descriptionController.text,
      ingredients: ingredientsController.text
          .split('\n')
          .where((item) => item.trim().isNotEmpty)
          .toList(),
      steps: stepsController.text
          .split('\n')
          .where((item) => item.trim().isNotEmpty)
          .toList(),
      category: selectedCategory,
    );
    Navigator.pop(context, recipe);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.recipe == null ? 'Add Recipe' : 'Edit Recipe'),
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
                minLines: 4,
                maxLines: 8,
                maxLength: 250,
                keyboardType: TextInputType.multiline,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  alignLabelWithHint: true,
                ),
              ),

              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                initialValue: selectedCategory,
                decoration: const InputDecoration(labelText: 'Category'),
                items: categories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCategory = value!;
                  });
                },
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
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _saveRecipe,
            child: const Text('Save Recipe'),
          ),
        ),
      ),
    );
  }
}
