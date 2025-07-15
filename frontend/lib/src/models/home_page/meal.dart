class MealEntry {
  final String name;
  final int calories;
  final double proteins;
  final double fats;
  final double carbs;

  MealEntry({
    required this.name,
    required this.calories,
    required this.proteins,
    required this.fats,
    required this.carbs,
  });
}

class Meal {
  final String type; // e.g., 'Breakfast', 'Lunch', etc.
  final List<MealEntry> entries;

  Meal({required this.type, this.entries = const []});
}
