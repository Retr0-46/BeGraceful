import 'meal.dart';
import 'activity.dart';

class DaySummary {
  final DateTime date;
  final List<Meal> meals;
  final List<Activity> activities;
  final int steps;

  final int caloriesGoal;
  final double carbsGoal;
  final double proteinsGoal;
  final double fatsGoal;

  DaySummary({
    required this.date,
    required this.meals,
    required this.activities,
    required this.steps,
    this.caloriesGoal = 1500,
    this.carbsGoal = 148,
    this.proteinsGoal = 50,
    this.fatsGoal = 39,
  });

  int get caloriesConsumed => meals
      .expand((meal) => meal.entries)
      .fold(0, (sum, entry) => sum + entry.calories);

  int get caloriesBurned => activities.fold(0, (sum, a) => sum + a.caloriesBurned) + stepsCalories;

  int get stepsCalories => (steps * 0.04).round(); // Пример формулы

  int get caloriesRemaining => (caloriesGoal - caloriesConsumed) < 0 ? 0 : (caloriesGoal - caloriesConsumed);

  double get carbs => meals.expand((meal) => meal.entries).fold(0.0, (sum, e) => sum + e.carbs);
  double get proteins => meals.expand((meal) => meal.entries).fold(0.0, (sum, e) => sum + e.proteins);
  double get fats => meals.expand((meal) => meal.entries).fold(0.0, (sum, e) => sum + e.fats);

  DaySummary copyWith({
    DateTime? date,
    List<Meal>? meals,
    List<Activity>? activities,
    int? steps,
  }) {
    return DaySummary(
      date: date ?? this.date,
      meals: meals ?? this.meals,
      activities: activities ?? this.activities,
      steps: steps ?? this.steps,
    );
  }

}
