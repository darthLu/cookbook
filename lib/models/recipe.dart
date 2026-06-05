class Recipe {
  final String name;
  final String description;
  final List<String> ingredients;
  final List<String> steps;
  final String cookTime;

  Recipe({
    required this.name,
    required this.description,
    required this.ingredients,
    required this.steps,
    required this.cookTime,
  });
}