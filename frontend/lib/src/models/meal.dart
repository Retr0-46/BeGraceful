class MealEntry {
  final String name;
  final int calories;
  final double protein;
  final double fat;
  final double carbs;

  MealEntry({
    required this.name,
    required this.calories,
    required this.protein,
    required this.fat,
    required this.carbs,
  });
}

class Meal {
  final String type; // e.g., 'Breakfast', 'Lunch', etc.
  final List<MealEntry> entries;

  Meal({required this.type, this.entries = const []});
}
