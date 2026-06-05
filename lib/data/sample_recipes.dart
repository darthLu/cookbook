import '../models/recipe.dart';

final List<Recipe> sampleRecipes = [
  Recipe(
    name: 'Spaghetti Bolognese',
    description: 'A classic Italian meat sauce pasta.',
    cookTime: '45 mins',
    ingredients: [
      '400g spaghetti',
      '500g ground beef',
      '1 onion, diced',
      '2 garlic cloves',
      '400g canned tomatoes',
      'Salt, pepper, olive oil',
    ],
    steps: [
      'Brown the ground beef in a pan.',
      'Add onion and garlic, cook until soft.',
      'Stir in canned tomatoes and simmer 20 mins.',
      'Cook spaghetti according to package.',
      'Serve sauce over spaghetti.',
    ],
  ),
  Recipe(
    name: 'Pancakes',
    description: 'Fluffy homemade breakfast pancakes.',
    cookTime: '20 mins',
    ingredients: [
      '1 cup flour',
      '1 cup milk',
      '1 egg',
      '2 tbsp sugar',
      '1 tsp baking powder',
      'Pinch of salt',
    ],
    steps: [
      'Mix dry ingredients together.',
      'Whisk in milk and egg until smooth.',
      'Heat a pan over medium heat.',
      'Pour batter and cook until bubbles form, then flip.',
      'Serve with syrup or fruit.',
    ],
  ),
  Recipe(
    name: 'Chicken Stir Fry',
    description: 'Quick and healthy weeknight dinner.',
    cookTime: '25 mins',
    ingredients: [
      '2 chicken breasts, sliced',
      '2 cups mixed vegetables',
      '3 tbsp soy sauce',
      '1 tbsp sesame oil',
      '2 garlic cloves',
      'Cooked rice to serve',
    ],
    steps: [
      'Heat oil in a wok over high heat.',
      'Cook chicken until golden.',
      'Add vegetables and garlic, stir fry 3-4 mins.',
      'Add soy sauce and sesame oil.',
      'Serve over rice.',
    ],
  ),
];