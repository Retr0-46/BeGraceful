import 'package:pedometer/pedometer.dart';
import 'dart:async';
import '../utils/config.dart';
import 'api_service.dart';

class StepService {
  static final Stream<StepCount> stepCountStream = Pedometer.stepCountStream;
  static int lastSentSteps = 0;

  // Отправить шаги на backend (каждые 100 шагов)
  static Future<void> sendStepsToBackend({required String userId, required int steps, required DateTime date}) async {
    final url = '${AppConfig.caloriesBaseUrl}/steps';
    final body = {
      'user_id': userId,
      'date': date.toIso8601String().substring(0, 10),
      'steps': steps,
    };
    final response = await ApiService.post(url, body: body);
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to send steps: ${response.body}');
    }
  }
}
