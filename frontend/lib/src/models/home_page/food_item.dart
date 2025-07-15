class FoodItem {
  final String id;
  final String name;
  final String unit; // e.g. "1 medium", "1 cup"
  final int calories;
  final double protein;
  final double fat;
  final double carbs;

  FoodItem({
    required this.id,
    required this.name,
    required this.unit,
    required this.calories,
    required this.protein,
    required this.fat,
    required this.carbs,
  });

  factory FoodItem.fromJson(Map<String, dynamic> json) {
    return FoodItem(
      id: json['id'],
      name: json['name'],
      unit: json['unit'],
      calories: json['calories'],
      protein: (json['protein'] as num).toDouble(),
      fat: (json['fat'] as num).toDouble(),
      carbs: (json['carbs'] as num).toDouble(),
    );
  }
}
