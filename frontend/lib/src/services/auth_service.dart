import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/registration_data.dart';

class AuthService {
  static Future<bool> register(String email, String password) async {
    final response = await http.post(
      Uri.parse('https://your-backend.com/api/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    return response.statusCode == 200;
  }

  /* static Future<void> register(RegistrationData data) async {
    final response = await http.post(
      Uri.parse('https://your-api.com/api/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': data.username,
        'email': data.email,
        'password': data.password,
        'gender': data.gender,
        'birth_date': data.birthDate?.toIso8601String(),
        'height': data.height,
        'activity_level': data.activityLevel,
        'goal': data.goal,
        'goal_weight': data.goalWeight,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to register');
    }
  } */
}
