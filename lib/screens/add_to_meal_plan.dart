import 'package:flutter/material.dart';
import '../models/recipe.dart';
import '../services/meal_plan_service.dart';

Future<void> addToMealPlan(BuildContext context, Recipe recipe) async {
  final day = await showModalBottomSheet<String>(
    context: context,
    showDragHandle: true,
    builder: (context) => SafeArea(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Plan ${recipe.name}',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            for (final day in MealPlanService.weekdays)
              ListTile(
                leading: const Icon(Icons.calendar_today_outlined),
                title: Text(day),
                onTap: () => Navigator.pop(context, day),
              ),
          ],
        ),
      ),
    ),
  );
  if (day == null) return;
  try {
    await MealPlanService.instance.add(day, recipe);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${recipe.name} planned for $day')),
      );
    }
  } catch (_) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not save your meal plan. Please try again.'),
        ),
      );
    }
  }
}
