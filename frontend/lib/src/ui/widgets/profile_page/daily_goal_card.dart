import 'package:flutter/material.dart';

class DailyGoalCard extends StatelessWidget {
  const DailyGoalCard({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Replace fake data for real calories, carbs, fats and proteins
    final int calories = 1600;
    final int protein = 148;
    final int carbs = 30;
    final int fat = 39;

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
                  'Daily Goal ',
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