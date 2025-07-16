import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/user_provider.dart';
import 'package:intl/intl.dart';

class DailyGoalCard extends StatelessWidget {
  const DailyGoalCard({super.key});

  int _calculateAge(DateTime birthDate) {
    final now = DateTime.now();
    int age = now.year - birthDate.year;
    if (now.month < birthDate.month || (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  double _activityMultiplier(String activityLevel) {
    switch (activityLevel.toLowerCase()) {
      case 'sedentary':
        return 1.2;
      case 'lightly active':
        return 1.375;
      case 'moderately active':
        return 1.55;
      case 'very active':
        return 1.725;
      case 'extra active':
        return 1.9;
      default:
        return 1.2;
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final profile = userProvider.profile;
    if (profile == null) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Center(child: Text('No profile data')),
        ),
      );
    }

    final gender = (profile['gender'] ?? '').toString().toLowerCase();
    final weight = (profile['current_weight_kg'] ?? profile['weight_kg'] ?? profile['weight'] ?? 70).toDouble();
    final height = (profile['height_cm'] ?? profile['height'] ?? 170).toDouble();
    final birth = profile['date_of_birth'];
    DateTime? birthDate;
    int age = 30;
    if (birth != null) {
      try {
        birthDate = DateTime.parse(birth);
        age = _calculateAge(birthDate);
      } catch (_) {}
    }
    final activityLevel = (profile['activity_level'] ?? 'sedentary').toString().toLowerCase();

    // BMR
    double bmr;
    if (gender.startsWith('m')) {
      bmr = 10 * weight + 6.25 * height - 5 * age + 5;
    } else {
      bmr = 10 * weight + 6.25 * height - 5 * age - 161;
    }
    final multiplier = _activityMultiplier(activityLevel);
    final calories = (bmr * multiplier).round();
    final protein = ((calories * 0.2) / 4).round();
    final fat = ((calories * 0.3) / 9).round();
    final carbs = ((calories * 0.5) / 4).round();

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'Daily Goal 🎯',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(width: 2),
                Image.asset(
                  'assets/images/profile_page/daily_goal_icon.png',
                  height: 20,
                  alignment: Alignment.bottomCenter,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Center(
              child: Column(
                children: [
                  Text(
                    '$calories',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'kcal',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF4B5563),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Text(
                      '$protein g',
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Protein',
                      style: TextStyle(
                        color: Color(0xFF4B5563),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      '$carbs g',
                      style: const TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Carbs',
                      style: TextStyle(
                        color: Color(0xFF4B5563),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      '$fat g',
                      style: const TextStyle(
                        color: Color(0xFFF59E0B), 
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Fat',
                      style: TextStyle(
                        color: Color(0xFF4B5563),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}