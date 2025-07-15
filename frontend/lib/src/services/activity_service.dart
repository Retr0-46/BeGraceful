import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/home_page/activity.dart';

class ActivityService {
  static Future<List<Activity>> fetchActivities() async {
    final response = await http.get(Uri.parse('https://your-backend-url.com/activities'));

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((json) => Activity.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load activities');
    }
  }
}
