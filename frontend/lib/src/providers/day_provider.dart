import 'dart:async';
import 'package:flutter/material.dart';
import '../models/home_page/day_summary.dart';
import '../models/home_page/meal.dart';
import '../models/home_page/activity.dart';
import '../services/meal_service.dart';
import '../services/auth_service.dart';
import '../services/api_service.dart';
import '../services/step_service.dart';
import 'package:pedometer/pedometer.dart';

class DayProvider extends ChangeNotifier {
  final Map<DateTime, DaySummary> _days = {};
  DateTime _selectedDate = DateTime.now();
  bool _isLoading = false;
  String? _error;
  StreamSubscription<StepCount>? _stepSub;
  int _lastSentSteps = 0;

  DateTime get selectedDate => _selectedDate;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Map<DateTime, DaySummary> get days => _days;

  DaySummary get currentDay => _days[_selectedDate] ?? _createEmptySummary(_selectedDate);

  void setDate(DateTime date) {
    _selectedDate = date;
    loadDayData();
  }

  Future<void> loadDayData() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final jwt = ApiService.getJwt();
      if (jwt == null) {
        _error = 'User not authenticated';
        return;
      }

      final userId = AuthService.getUserIdFromJwt(jwt);
      if (userId == null) {
        _error = 'Invalid JWT token';
        return;
      }

      final dateStr = _formatDate(_selectedDate);
      
      // Загружаем данные с backend
      List<MealEntry> foodEntries = [];
      List<Activity> workoutEntries = [];
      
      try {
        foodEntries = await CaloriesService.getFoodEntries(userId: userId, date: dateStr);
      } catch (e) {
        print('Error loading food entries: $e');
        foodEntries = [];
      }
      
      try {
        workoutEntries = await CaloriesService.getWorkoutEntries(userId: userId, date: dateStr);
      } catch (e) {
        print('Error loading workout entries: $e');
        workoutEntries = [];
      }

      // Группируем еду по типам приемов пищи
      final meals = _groupFoodEntriesByMealType(foodEntries);
      
      // Создаем активности из записей о тренировках
      final activities = workoutEntries;

      _days[_selectedDate] = DaySummary(
        date: _selectedDate,
        meals: meals,
        activities: activities,
        steps: 5000, // TODO: загрузить реальные шаги
      );
    } catch (e) {
      _error = e.toString();
      print('Error in loadDayData: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addMeal(String type, MealEntry entry) async {
    // 1. Сначала обновляем локальное состояние
    final day = currentDay;
    final meals = [...day.meals];
    final mealIndex = meals.indexWhere((m) => m.type == type);
    final entryWithType = MealEntry(
      name: entry.name,
      calories: entry.calories,
      proteins: entry.proteins,
      fats: entry.fats,
      carbs: entry.carbs,
      mealType: type,
    );
    if (mealIndex != -1) {
      final existingMeal = meals[mealIndex];
      final updatedEntries = List<MealEntry>.from(existingMeal.entries)..add(entryWithType);
      meals[mealIndex] = Meal(type: type, entries: updatedEntries);
    } else {
      meals.add(Meal(type: type, entries: [entryWithType]));
    }
    _days[_selectedDate] = DaySummary(
      date: _selectedDate,
      meals: meals,
      activities: day.activities,
      steps: day.steps,
    );
    notifyListeners();

    // 2. Параллельно отправляем запрос на сервер
    try {
      final jwt = ApiService.getJwt();
      if (jwt == null) {
        _error = 'User not authenticated';
        notifyListeners();
        return;
      }
      final userId = AuthService.getUserIdFromJwt(jwt);
      if (userId == null) {
        _error = 'Invalid JWT token';
        notifyListeners();
        return;
      }
      final dateStr = _formatDate(_selectedDate);
      await CaloriesService.addFood(
        userId: userId,
        date: dateStr,
        name: entry.name,
        calories: entry.calories,
        proteins: entry.proteins ?? 0.0,
        fats: entry.fats ?? 0.0,
        carbs: entry.carbs ?? 0.0,
        mealType: type.toLowerCase(),
      );
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // Обновить прием пищи (используется при добавлении/удалении элементов)
  Future<void> updateMeal(Meal updatedMeal) async {
    try {
      final jwt = ApiService.getJwt();
      if (jwt == null) {
        _error = 'User not authenticated';
        notifyListeners();
        return;
      }

      final userId = AuthService.getUserIdFromJwt(jwt);
      if (userId == null) {
        _error = 'Invalid JWT token';
        notifyListeners();
        return;
      }

      final dateStr = _formatDate(_selectedDate);
      
      // Для каждого элемента в обновленном приеме пищи сохраняем на сервер
      for (final entry in updatedMeal.entries) {
        await CaloriesService.addFood(
          userId: userId,
          date: dateStr,
          name: entry.name,
          calories: entry.calories,
          proteins: entry.proteins,
          fats: entry.fats,
          carbs: entry.carbs,
          mealType: updatedMeal.type.toLowerCase(),
        );
      }

      // Обновляем локальное состояние
      final day = currentDay;
      final meals = [...day.meals];
      final mealIndex = meals.indexWhere((m) => m.type == updatedMeal.type);
      if (mealIndex != -1) {
        meals[mealIndex] = updatedMeal;
      } else {
        meals.add(updatedMeal);
      }
      
      _days[_selectedDate] = DaySummary(
        date: _selectedDate,
        meals: meals,
        activities: day.activities,
        steps: day.steps,
      );
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> addActivity(Activity activity) async {
    try {
      final jwt = ApiService.getJwt();
      if (jwt == null) {
        _error = 'User not authenticated';
        notifyListeners();
        return;
      }

      final userId = AuthService.getUserIdFromJwt(jwt);
      if (userId == null) {
        _error = 'Invalid JWT token';
        notifyListeners();
        return;
      }

      final dateStr = _formatDate(_selectedDate);
      
      // Сохраняем в backend
      await CaloriesService.addWorkout(
        userId: userId,
        date: dateStr,
        name: activity.name,
        durationMinutes: activity.durationMinutes,
        caloriesBurned: activity.caloriesBurned,
      );

      // Обновляем локальное состояние
      final day = currentDay;
      _days[_selectedDate] = DaySummary(
        date: _selectedDate,
        meals: day.meals,
        activities: [...day.activities, activity],
        steps: day.steps,
      );
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
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

  void initStepTracking(String userId) {
    _stepSub?.cancel();
    _stepSub = StepService.stepCountStream.listen((StepCount event) async {
      final today = DateTime.now();
      final todayKey = DateTime(today.year, today.month, today.day);
      final steps = event.steps;
      // Обновляем локально
      final summary = _days[todayKey] ?? _createEmptySummary(todayKey);
      _days[todayKey] = summary.copyWith(steps: steps);
      notifyListeners();
      // Отправляем на backend каждые 100 шагов
      if ((steps - _lastSentSteps).abs() >= 100) {
        try {
          await StepService.sendStepsToBackend(userId: userId, steps: steps, date: today);
          _lastSentSteps = steps;
        } catch (e) {
          // Можно обработать ошибку
        }
      }
    });
  }

  void disposeStepTracking() {
    _stepSub?.cancel();
    _stepSub = null;
  }

  DaySummary _createEmptySummary(DateTime date) {
    final summary = DaySummary(date: date, meals: [], activities: [], steps: 0);
    _days[date] = summary;
    return summary;
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  List<Meal> _groupFoodEntriesByMealType(List<MealEntry> entries) {
    final Map<String, List<MealEntry>> grouped = {
      'Breakfast': [],
      'Lunch': [],
      'Dinner': [],
      'Snacks': [],
    };
    for (final entry in entries) {
      final type = entry.mealType;
      if (grouped.containsKey(type)) {
        grouped[type]!.add(entry);
      } else {
        grouped['Breakfast']!.add(entry); // fallback
      }
    }
    return grouped.entries.map((entry) => Meal(type: entry.key, entries: entry.value)).toList();
  }
}
