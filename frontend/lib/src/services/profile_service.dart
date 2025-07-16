import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/config.dart';
import 'api_service.dart';

class ProfileService {
  // Получить профиль пользователя по user_id
  static Future<Map<String, dynamic>> getProfile(String userId) async {
    final response = await ApiService.get('${AppConfig.profileBaseUrl}/$userId');
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['data'];
    } else {
      throw Exception('Failed to get profile: ${response.body}');
    }
  }

  // Обновить профиль пользователя (например, вес)
  static Future<void> updateProfile(Map<String, dynamic> profileData) async {
    final userId = profileData['user_id'];
    if (userId == null) {
      throw Exception('user_id is required for profile update');
    }
    
    final response = await ApiService.put(
      '${AppConfig.profileBaseUrl}/$userId',
      body: profileData,
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update profile: ${response.body}');
    }
  }

  // Обновить только вес пользователя
  static Future<void> updateWeight(String userId, int weightKg) async {
    final response = await ApiService.patch(
      '${AppConfig.profileBaseUrl}/$userId/weight',
      body: {'weight_kg': weightKg},
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update weight: ${response.body}');
    }
  }
} 