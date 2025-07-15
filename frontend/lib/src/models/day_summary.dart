import 'meal.dart';
import 'activity.dart';

class DaySummary {
  final DateTime date;
  final List<Meal> meals;
  final List<Activity> activities;
  final int steps;

  DaySummary({
    required this.date,
    required this.meals,
    required this.activities,
    required this.steps,
  });

  int get caloriesConsumed => meals
      .expand((meal) => meal.entries)
      .fold(0, (sum, entry) => sum + entry.calories);

  int get caloriesBurned => activities.fold(0, (sum, a) => sum + a.caloriesBurned) + stepsCalories;

  int get stepsCalories => (steps * 0.04).round(); // Пример формулы
}
