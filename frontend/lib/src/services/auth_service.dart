import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/registration_data.dart';
import '../utils/config.dart';
import 'api_service.dart';

class AuthService {
  // Регистрация/логин (step 1)
  static Future<Map<String, dynamic>> register(String email, String password) async {
    final response = await ApiService.post(
      '${AppConfig.authBaseUrl}/register',
      body: {'email': email, 'password': password},
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to register: ${response.body}');
    }
  }

  // Завершение профиля (step 2)
  static Future<Map<String, dynamic>> completeProfile(Map<String, dynamic> profileData) async {
    final response = await ApiService.post(
      '${AppConfig.authBaseUrl}/complete-profile',
      body: profileData,
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['data']?['jwt'] != null) {
        ApiService.setJwt(data['data']['jwt']);
      }
      return data;
    } else {
      throw Exception('Failed to complete profile: ${response.body}');
    }
  }

  // Сохранить JWT после логина/регистрации
  static void saveJwt(String jwt) {
    ApiService.setJwt(jwt);
  }

  // Логин пользователя
  static Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await ApiService.post(
      '${AppConfig.authBaseUrl}/register',
      body: {'email': email, 'password': password},
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // Если профиль завершён — есть jwt
      if (data['data']?['jwt'] != null) {
        return {'jwt': data['data']['jwt'], 'status': data['data']['status']};
      }
      // Если профиль не завершён — есть user_id
      if (data['data']?['user_id'] != null) {
        return {'user_id': data['data']['user_id'], 'status': data['data']['status']};
      }
      throw Exception('Login failed: Unexpected response');
    } else if (response.statusCode == 401) {
      throw Exception('Invalid email or password');
    } else {
      throw Exception('Failed to login: ${response.body}');
    }
  }

  // Декодировать userId из jwt
  static String? getUserIdFromJwt(String jwt) {
    try {
      final parts = jwt.split('.');
      if (parts.length != 3) return null;
      final payload = utf8.decode(base64Url.decode(base64Url.normalize(parts[1])));
      final payloadMap = jsonDecode(payload);
      return payloadMap['user_id'] ?? payloadMap['sub'];
    } catch (_) {
      return null;
    }
  }

  // Выйти из системы
  static void logout() {
    ApiService.setJwt(null);
  }
}
