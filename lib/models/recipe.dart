class Recipe {
  String name;
  String description;
  List<String> ingredients;
  List<String> steps;
  String cookTime;

  Recipe({
    required this.name,
    required this.description,
    required this.ingredients,
    required this.steps,
    required this.cookTime,
  });
}