class Recipe {
  String name;
  String description;
  List<String> ingredients;
  List<String> steps;
  String cookTime;
  String category;

  Recipe({
    required this.name,
    required this.description,
    required this.ingredients,
    required this.steps,
    required this.cookTime,
    required this.category,
  });
}