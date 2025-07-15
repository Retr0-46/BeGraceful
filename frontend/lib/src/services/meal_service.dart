import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/home_page/food_item.dart';

class FoodService {
  final String baseUrl;

  FoodService({required this.baseUrl});

  Future<List<FoodItem>> fetchFoodItems() async {
    final response = await http.get(Uri.parse('$baseUrl/foods'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => FoodItem.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load food items');
    }
  }
}
