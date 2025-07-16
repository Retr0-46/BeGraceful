import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart' show rootBundle;
import '../utils/config.dart';
import 'api_service.dart';
import '../models/home_page/meal.dart';
import '../models/home_page/activity.dart';

class CaloriesService {
  // Добавить запись о съеденной пище
  static Future<void> addFood({
    required String userId, 
    required String date, 
    required String name,
    required int calories,
    required double proteins,
    required double fats,
    required double carbs,
    required String mealType,
  }) async {
    final response = await ApiService.post(
      '${AppConfig.caloriesBaseUrl}/food',
      body: {
        'user_id': userId,
        'entry_date': date,
        'name': name,
        'calories': calories,
        'proteins': proteins,
        'fats': fats,
        'carbs': carbs,
        'meal_type': mealType,
      },
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to add food: ${response.body}');
    }
  }

  // Добавить запись о тренировке
  static Future<void> addWorkout({
    required String userId, 
    required String date, 
    required String name,
    required int durationMinutes,
    required int caloriesBurned,
  }) async {
    final response = await ApiService.post(
      '${AppConfig.caloriesBaseUrl}/workout',
      body: {
        'user_id': userId,
        'entry_date': date,
        'name': name,
        'duration_minutes': durationMinutes,
        'calories_burned': caloriesBurned,
      },
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to add workout: ${response.body}');
    }
  }

  // Получить дневную сводку по калориям
  static Future<Map<String, dynamic>> getSummary({required String userId, required String date}) async {
    final url = '${AppConfig.caloriesBaseUrl}/summary?user_id=$userId&date=$date';
    final response = await ApiService.get(url);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to get summary: ${response.body}');
    }
  }

  // Получить записи о еде за день
  static Future<List<MealEntry>> getFoodEntries({required String userId, required String date}) async {
    final url = '${AppConfig.caloriesBaseUrl}/food?user_id=$userId&date=$date';
    final response = await ApiService.get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final entries = data['data'] as List?;
      if (entries == null) {
        return [];
      }
      return entries.map((entry) => MealEntry(
        name: entry['name'] ?? '',
        calories: entry['calories'] ?? 0,
        proteins: (entry['proteins'] as num?)?.toDouble() ?? 0.0,
        fats: (entry['fats'] as num?)?.toDouble() ?? 0.0,
        carbs: (entry['carbs'] as num?)?.toDouble() ?? 0.0,
        mealType: entry['meal_type'] ?? 'Breakfast',
      )).toList();
    } else {
      throw Exception('Failed to get food entries: ${response.body}');
    }
  }

  // Получить записи о тренировках за день
  static Future<List<Activity>> getWorkoutEntries({required String userId, required String date}) async {
    final url = '${AppConfig.caloriesBaseUrl}/workout?user_id=$userId&date=$date';
    final response = await ApiService.get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final entries = data['data'] as List?;
      if (entries == null) {
        return [];
      }
      return entries.map((entry) => Activity(
        id: entry['id'] ?? '',
        name: entry['name'] ?? '',
        durationMinutes: entry['duration_minutes'] ?? 0,
        caloriesPerMinute: entry['duration_minutes'] != null && entry['duration_minutes'] > 0 
            ? (entry['calories_burned'] / entry['duration_minutes']).toDouble()
            : 0.0,
      )).toList();
    } else {
      throw Exception('Failed to get workout entries: ${response.body}');
    }
  }

  // Получить список продуктов из CSV файла
  static Future<List<Map<String, dynamic>>> fetchFoodItems() async {
    print('fetchFoodItems called');
    try {
      final String csvData = await rootBundle.loadString('assets/products.csv');
      final List<String> lines = csvData.split('\n');
      final List<Map<String, dynamic>> products = [];
      for (int i = 1; i < lines.length; i++) {
        final String line = lines[i].trim();
        if (line.isEmpty) continue;
        final List<String> values = line.split(',');
        if (values.length >= 5) {
          products.add({
            'id': i.toString(),
            'name': values[0],
            'unit': '100g',
            'calories': double.tryParse(values[1])?.round() ?? 0,
            'protein': double.tryParse(values[2]) ?? 0.0,
            'fat': double.tryParse(values[3]) ?? 0.0,
            'carbs': double.tryParse(values[4]) ?? 0.0,
          });
        }
      }
      print('Loaded  [32m${products.length} [0m products from CSV');
      return products;
    } catch (e) {
      print('Error loading CSV file: $e');
      return [];
    }
  }
}
