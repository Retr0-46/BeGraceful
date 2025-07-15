import 'package:flutter/material.dart';
import '../models/home_page/food_item.dart';
import '../services/meal_service.dart';

class FoodProvider extends ChangeNotifier {
  final FoodService foodService;

  FoodProvider({required this.foodService});

  List<FoodItem> _foodItems = [];
  bool _isLoading = false;
  String? _error;

  List<FoodItem> get foodItems => _foodItems;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadFoodItems() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _foodItems = await foodService.fetchFoodItems();
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }
}
