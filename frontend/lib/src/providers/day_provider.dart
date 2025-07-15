import 'package:flutter/material.dart';
import '../models/home_page/day_summary.dart';
import '../models/home_page/meal.dart';
import '../models/home_page/activity.dart';

class DayProvider extends ChangeNotifier {
  final Map<DateTime, DaySummary> _days = {};
  DateTime _selectedDate = DateTime.now();

  DateTime get selectedDate => _selectedDate;

  DaySummary get currentDay => _days[_selectedDate] ?? _createEmptySummary(_selectedDate);

  void setDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  void addMeal(String type, MealEntry entry) {
    final day = currentDay;
    final meals = [...day.meals];
    final mealIndex = meals.indexWhere((m) => m.type == type);
    if (mealIndex != -1) {
      meals[mealIndex].entries.add(entry);
    } else {
      meals.add(Meal(type: type, entries: [entry]));
    }
    _days[_selectedDate] = DaySummary(
      date: _selectedDate,
      meals: meals,
      activities: day.activities,
      steps: day.steps,
    );
    notifyListeners();
  }

  void addActivity(Activity activity) {
    final day = currentDay;
    _days[_selectedDate] = DaySummary(
      date: _selectedDate,
      meals: day.meals,
      activities: [...day.activities, activity],
      steps: day.steps,
    );
    notifyListeners();
  }

  void setSteps(int steps) {
    final day = currentDay;
    _days[_selectedDate] = DaySummary(
      date: _selectedDate,
      meals: day.meals,
      activities: day.activities,
      steps: steps,
    );
    notifyListeners();
  }

  DaySummary _createEmptySummary(DateTime date) {
    final summary = DaySummary(date: date, meals: [], activities: [], steps: 0);
    _days[date] = summary;
    return summary;
  }
}
