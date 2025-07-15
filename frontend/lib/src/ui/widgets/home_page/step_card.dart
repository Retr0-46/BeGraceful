import 'package:flutter/material.dart';

class StepsCard extends StatelessWidget {
  final int steps;
  final int caloriesBurned;

  const StepsCard({
    super.key,
    required this.steps,
    required this.caloriesBurned,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '$steps',
              style: const TextStyle(color: Colors.green, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              '≈ $caloriesBurned kcal burned',
              style: const TextStyle(color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
