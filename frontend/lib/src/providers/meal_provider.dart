import 'package:flutter/material.dart';
import '../models/home_page/food_item.dart';
import '../services/meal_service.dart';

class FoodProvider extends ChangeNotifier {
  List<FoodItem> _foodItems = [];
  bool _isLoading = false;
  String? _error;

  List<FoodItem> get foodItems => _foodItems;
  bool get isLoading => _isLoading;
  String? get error => _error;

  FoodProvider() {
    loadFoodItems();
  }

  Future<void> loadFoodItems() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final items = await CaloriesService.fetchFoodItems();
      _foodItems = items.map((item) => FoodItem.fromJson(item)).toList();
    } catch (e) {
      _error = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }
}
